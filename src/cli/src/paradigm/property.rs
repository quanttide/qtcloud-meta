//! 范式内·属性校准：字段用法对着标准属性表逐条核。
//!
//! 设计参照 category（`paradigm`）工具：标准表文件优先装载、快照保底；报告走
//! [`super::common::Report`]，装载 → 标准自检 → 校准 → 结论四步轨迹；md 与 JSON
//! 两个出口共用同一份数据；`--strict` 任一失败即非零。标准外的字段不停机，进
//! 待收录清单，指到该补的标准表文件——补完复跑即接上。
//!
//! 标准表按 OpenAPI 风格写：`type` 是数据类型，`format`／`pattern`／`enum` 是修饰；
//! `type` 本身也是九条确认的标准属性之一。

use std::collections::HashSet;
use std::path::PathBuf;

use regex::Regex;
use serde::{Deserialize, Serialize};
use serde_yml::Value;

use super::common::{
    Report, Results, Step, StepStatus, find_table_file, render_json, render_markdown,
};

// ───────────────────────── 标准表 schema ─────────────────────────

/// OpenAPI 数据类型（标量与容器），标准表的 `type` 只认这些。
const OPENAPI_TYPES: [&str; 6] = ["string", "number", "integer", "boolean", "array", "object"];

/// 分组名与机器标识共用的形状：小写、连字符、英文。
static MACHINE_NAME: std::sync::OnceLock<Regex> = std::sync::OnceLock::new();

fn machine_name() -> &'static Regex {
    MACHINE_NAME
        .get_or_init(|| Regex::new("^[a-z][a-z0-9]*(-[a-z0-9]+)*$").expect("内置 pattern 应能编译"))
}

/// 标准属性表：一条属性一个定义，schema 关键字按 OpenAPI 风格平铺。
#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct Standard {
    pub name: String,
    #[serde(default)]
    pub version: Option<String>,
    #[serde(default)]
    pub properties: Vec<PropertyDef>,
}

/// 一条标准属性。`type` 是 OpenAPI 数据类型，`format`／`pattern`／`enum` 是它的修饰。
#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct PropertyDef {
    pub name: String,
    /// 分组：英文机器名；它同时是九条标准属性之一（用户自定义类别），与 type 同款双义。
    #[serde(default)]
    pub category: String,
    /// `confirmed` 或 `suspected`，缺省按怀疑算。
    #[serde(default)]
    pub status: String,
    #[serde(rename = "type")]
    pub typ: String,
    #[serde(default)]
    pub format: Option<String>,
    #[serde(default)]
    pub pattern: Option<String>,
    #[serde(default, rename = "enum")]
    pub enum_values: Option<Vec<String>>,
    #[serde(default)]
    pub description: String,
}

impl PropertyDef {
    pub fn status_key(&self) -> &'static str {
        if self.status.trim() == "confirmed" {
            "confirmed"
        } else {
            "suspected"
        }
    }

    pub fn status_label(&self) -> &'static str {
        if self.status_key() == "confirmed" {
            "确认"
        } else {
            "怀疑"
        }
    }
}

// ───────────────────────── 装载 ─────────────────────────

/// 标准表目录：从当前目录向上找 `examples/property/`。
const TABLE_SUBDIR: &str = "examples/property";
const STANDARD_FILE: &str = "standard.yaml";

/// 装进二进制的标准表快照：仓库外运行、向上找不到表目录时保底。
const BUILTIN: &str = include_str!("../../examples/property/standard.yaml");

/// 读标准表并做标准自检。文件优先（向上找 `examples/property/standard.yaml`），
/// 找不到用内置快照；来源写进报告的装载步。
pub fn load_standard() -> Result<(Standard, String), String> {
    let (text, source) = match find_table_file(TABLE_SUBDIR, STANDARD_FILE) {
        Some(path) => {
            let text = std::fs::read_to_string(&path)
                .map_err(|e| format!("读取 {} 失败：{e}", path.display()))?;
            (text, format!("文件 {}", path.display()))
        }
        None => (
            BUILTIN.to_string(),
            "内置快照（当前目录向上未找到表目录）".to_string(),
        ),
    };
    let standard: Standard =
        serde_yml::from_str(&text).map_err(|e| format!("标准表解析失败：{e}"))?;
    standard_self_check(&standard)?;
    Ok((standard, source))
}

/// 标准自检：标准自己先得站得住，站不住就拒绝校准。
///
/// 查四件：type 是 OpenAPI 数据类型、pattern 编译得过、枚举非空、属性名不重复。
fn standard_self_check(standard: &Standard) -> Result<(), String> {
    if standard.properties.is_empty() {
        return Err("标准表没有属性：在 properties 里补".to_string());
    }
    let mut seen: HashSet<&str> = HashSet::new();
    for property in &standard.properties {
        if !seen.insert(property.name.as_str()) {
            return Err(format!("标准表里属性 {} 重复", property.name));
        }
        if !machine_name().is_match(&property.category) {
            return Err(format!(
                "属性 {} 的 category「{}」不是英文机器名",
                property.name, property.category
            ));
        }
        if !OPENAPI_TYPES.contains(&property.typ.as_str()) {
            return Err(format!(
                "属性 {} 的 type「{}」不是 OpenAPI 数据类型（认 {}）",
                property.name,
                property.typ,
                OPENAPI_TYPES.join("、")
            ));
        }
        if let Some(pattern) = &property.pattern {
            Regex::new(pattern)
                .map_err(|error| format!("属性 {} 的 pattern 编译失败：{error}", property.name))?;
        }
        if property
            .enum_values
            .as_ref()
            .is_some_and(|values| values.is_empty())
        {
            return Err(format!("属性 {} 的 enum 是空的", property.name));
        }
    }
    Ok(())
}

// ───────────────────────── 校准 ─────────────────────────

/// 标准外字段：目标里有、标准表没收的字段，进待收录清单。
#[derive(Debug, Clone, Serialize)]
pub struct UnknownField {
    pub file: String,
    pub path: String,
}

/// 校准结果：命中、通过、失败、待收录四样。
#[derive(Debug, Clone, Serialize)]
pub struct CalibratedInfo {
    pub files: usize,
    /// 目标里出现、且标准收了的字段处数。
    pub hits: usize,
    pub passed: usize,
    pub failed: usize,
    /// 每条：`文件::路径：原因`。
    pub failures: Vec<String>,
    /// 标准外字段，待收录。
    pub unknown: Vec<UnknownField>,
}

/// CLI 选项。
pub struct Options {
    pub format: String,
    pub out: Option<PathBuf>,
    pub strict: bool,
}

/// 走完整条流程：装载标准 → 逐文件校准 → 渲染。
///
/// 目标文件解析失败按错误退出；校准出的失败是事实，进报告，`--strict` 才转非零。
pub fn run(files: &[PathBuf], options: &Options) -> Result<(), String> {
    match options.format.as_str() {
        "md" | "json" => {}
        other => return Err(format!("未知输出格式 {other}，只支持 md 或 json")),
    }
    let (standard, source) = load_standard()?;

    let mut info = CalibratedInfo {
        files: 0,
        hits: 0,
        passed: 0,
        failed: 0,
        failures: Vec::new(),
        unknown: Vec::new(),
    };
    let standard_path = find_table_file(TABLE_SUBDIR, STANDARD_FILE)
        .map(|path| path.canonicalize().unwrap_or(path));
    for file in files {
        let text = std::fs::read_to_string(file)
            .map_err(|e| format!("读取 {} 失败：{e}", file.display()))?;
        // 标准表自己是尺子不是测量对象：通用走查会把它的 schema 关键字
        // （type／format／pattern／enum）当成文档属性误伤，标准已经走结构自检。
        if file.canonicalize().ok().as_ref() == standard_path.as_ref() {
            continue;
        }
        let label = file.display().to_string();
        calibrate_text(&label, &text, &standard, &mut info)?;
        info.files += 1;
    }

    let report = build_report(&standard, &source, info);
    let text = match options.format.as_str() {
        "md" => render_markdown(&report),
        _ => format!("{}\n", render_json(&report)?),
    };
    match &options.out {
        Some(path) => {
            std::fs::write(path, text).map_err(|e| format!("写入 {} 失败：{e}", path.display()))?;
        }
        None => print!("{text}"),
    }

    let failed = report
        .results
        .calibrated
        .as_ref()
        .map_or(0, |calibrated| calibrated.failed);
    if options.strict && failed > 0 {
        return Err(format!("严格模式：有 {failed} 处属性校准失败"));
    }
    Ok(())
}

/// 校准一份 YAML 文本：逐键对着标准核，标准外的字段记进待收录。
fn calibrate_text(
    label: &str,
    text: &str,
    standard: &Standard,
    info: &mut CalibratedInfo,
) -> Result<(), String> {
    let document: Value =
        serde_yml::from_str(text).map_err(|e| format!("{label} 解析失败：{e}"))?;
    walk(label, "", &document, standard, info);
    Ok(())
}

fn walk(label: &str, path: &str, value: &Value, standard: &Standard, info: &mut CalibratedInfo) {
    match value {
        Value::Mapping(map) => {
            for (key, child) in map {
                let here = if path.is_empty() {
                    key.clone()
                } else {
                    format!("{path}.{key}")
                };
                match standard
                    .properties
                    .iter()
                    .find(|property| property.name == *key)
                {
                    Some(property) => {
                        info.hits += 1;
                        let failures = check_value(property, child, &here);
                        if failures.is_empty() {
                            info.passed += 1;
                        } else {
                            info.failed += 1;
                            for failure in failures {
                                info.failures.push(format!("{label}::{failure}"));
                            }
                        }
                    }
                    None => info.unknown.push(UnknownField {
                        file: label.to_string(),
                        path: here.clone(),
                    }),
                }
                walk(label, &here, child, standard, info);
            }
        }
        Value::Sequence(items) => {
            for (index, item) in items.iter().enumerate() {
                walk(label, &format!("{path}[{index}]"), item, standard, info);
            }
        }
        _ => {}
    }
}

/// 单处校验：按标准的 type／format／pattern／enum 逐项过。
/// 返回空 vec 即通过；每条是一句「路径：原因」。
fn check_value(property: &PropertyDef, value: &Value, at: &str) -> Vec<String> {
    // 本表当前只声明 string；其余类型出现时按未实现处理，不误报。
    if property.typ != "string" {
        return Vec::new();
    }
    let Some(text) = value.as_str() else {
        return vec![format!("{at}：type 应为 string，实为{}", kind_of(value))];
    };
    let mut failures = Vec::new();
    if let Some(values) = &property.enum_values
        && !values.iter().any(|value| value == text)
    {
        failures.push(format!(
            "{at}：「{text}」不在枚举 [{}] 里",
            values.join("、")
        ));
    }
    if let Some(pattern) = &property.pattern
        && let Ok(regex) = Regex::new(pattern)
        && !regex.is_match(text)
    {
        failures.push(format!("{at}：「{text}」不合 pattern {pattern}"));
    }
    if property.format.as_deref() == Some("uuid") && !is_uuid(text) {
        failures.push(format!("{at}：「{text}」不是 uuid"));
    }
    failures
}

fn kind_of(value: &Value) -> &'static str {
    match value {
        Value::Sequence(_) => "数组",
        Value::Mapping(_) => "对象",
        Value::Number(_) => "数字",
        Value::Bool(_) => "布尔",
        _ => "空",
    }
}

/// uuid 形状：8-4-4-4-12，段间是连字符，段内是十六进制。
fn is_uuid(text: &str) -> bool {
    let bytes = text.as_bytes();
    bytes.len() == 36
        && [8, 13, 18, 23].iter().all(|&index| bytes[index] == b'-')
        && text
            .chars()
            .enumerate()
            .filter(|(index, _)| ![8, 13, 18, 23].contains(index))
            .all(|(_, ch)| ch.is_ascii_hexdigit())
}

// ───────────────────────── 报告 ─────────────────────────

/// 装配报告：四步轨迹 + 校准结果。
pub fn build_report(standard: &Standard, source: &str, info: CalibratedInfo) -> Report {
    let mut conclusion = vec![
        format!(
            "命中标准属性 {} 处：通过 {}，失败 {}；标准外字段 {} 处。",
            info.hits,
            info.passed,
            info.failed,
            info.unknown.len()
        ),
        "失败是目标与标准的偏差，逐条改目标或改标准，改哪边由标准的维护者定。".to_string(),
    ];
    if !info.unknown.is_empty() {
        conclusion.push(
            "标准外字段进待收录清单：要收进标准，补 examples/property/standard.yaml 后复跑即接上。"
                .to_string(),
        );
    }

    Report {
        category: standard.name.clone(),
        from: None,
        to: None,
        source: standard.version.clone(),
        trace: vec![
            Step {
                name: "装载".to_string(),
                status: StepStatus::Done,
                note: Some(format!("标准表来源：{source}")),
            },
            Step {
                name: "标准自检".to_string(),
                status: StepStatus::Done,
                note: Some(format!(
                    "{} 条属性：type 都是 OpenAPI 类型，pattern 编译得过，枚举非空",
                    standard.properties.len()
                )),
            },
            Step {
                name: "校准".to_string(),
                status: StepStatus::Done,
                note: Some(format!(
                    "{} 个文件：命中 {} 处，通过 {}，失败 {}，待收录 {} 处",
                    info.files,
                    info.hits,
                    info.passed,
                    info.failed,
                    info.unknown.len()
                )),
            },
            Step {
                name: "结论".to_string(),
                status: StepStatus::Done,
                note: None,
            },
        ],
        results: Results {
            loaded: None,
            analyzed: None,
            translation: None,
            calibrated: Some(info),
        },
        relations: Vec::new(),
        conclusion,
        pending: None,
    }
}

// ───────────────────────── 测试 ─────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn standard() -> Standard {
        let (standard, _) = load_standard().expect("标准表应能装载");
        standard
    }

    fn value(text: &str) -> Value {
        Value::String(text.to_string())
    }

    fn check(name: &str, sample: &Value) -> Vec<String> {
        let standard = standard();
        let property = standard
            .properties
            .iter()
            .find(|property| property.name == name)
            .unwrap_or_else(|| panic!("标准里没有 {name}"));
        check_value(property, sample, name)
    }

    /// 标准表装得进、自检过：type 全是 OpenAPI 类型，pattern 编译得过。
    #[test]
    fn 标准表装载并通过自检() {
        let standard = standard();
        assert_eq!(standard.name, "qtcloud-property-standard");
        assert_eq!(standard.properties.len(), 9);
        standard_self_check(&standard).expect("自检应通过");
        // 分组用英文机器名：五个组各归其位。
        let categories: Vec<&str> = standard
            .properties
            .iter()
            .map(|property| property.category.as_str())
            .collect();
        assert_eq!(
            categories,
            vec![
                "identity",
                "identity",
                "identity",
                "identity",
                "classification",
                "classification",
                "location",
                "status",
                "content"
            ]
        );
    }

    /// name 的 pattern：小写连字符英文过，大写与空格不过。
    #[test]
    fn name只收小写连字符英文() {
        assert!(check("name", &value("report")).is_empty());
        assert!(check("name", &value("data-report-1")).is_empty());
        assert!(!check("name", &value("Report")).is_empty());
        assert!(!check("name", &value("data report")).is_empty());
    }

    /// type 的枚举：格的取值过，命令行字段值不过。
    #[test]
    fn type只收陈述型与程序型() {
        assert!(check("type", &value("陈述型")).is_empty());
        assert!(check("type", &value("程序型")).is_empty());
        let failures = check("type", &value("cardinality"));
        assert!(!failures.is_empty());
        assert!(failures[0].contains("枚举"));
    }

    /// id 的 format：uuid 形状过，slug 不过。
    #[test]
    fn id收uuid形状() {
        assert!(check("id", &value("550e8400-e29b-41d4-a716-446655440000")).is_empty());
        let failures = check("id", &value("ax-report-has-trace"));
        assert!(!failures.is_empty());
        assert!(failures[0].contains("uuid"));
    }

    /// path 的 pattern：目录以 / 结尾，文件带扩展名。
    #[test]
    fn path收目录与文件() {
        assert!(check("path", &value("data/report/")).is_empty());
        assert!(check("path", &value("src/main.rs")).is_empty());
        assert!(!check("path", &value("data report")).is_empty());
    }

    /// 非字符串按类型报，不 panic。
    #[test]
    fn 对象装进字符串字段按失败报() {
        let failures = check("label", &serde_yml::Value::Mapping(Default::default()));
        assert_eq!(failures.len(), 1);
        assert!(failures[0].contains("对象"));
    }

    /// 逐键走查：标准内的字段核值，标准外的进待收录，嵌套键也走得到。
    #[test]
    fn 走查分得清标准内外与嵌套() {
        let text = "name: ok-report\nlabel: { zh: 报告 }\nmeta:\n  note: x\n";
        let standard = standard();
        let mut info = CalibratedInfo {
            files: 0,
            hits: 0,
            passed: 0,
            failed: 0,
            failures: Vec::new(),
            unknown: Vec::new(),
        };
        calibrate_text("demo.yaml", text, &standard, &mut info).expect("应能解析");
        assert_eq!(info.hits, 2, "name 与 label 都命中");
        assert_eq!(info.passed, 1, "name 过");
        assert_eq!(info.failed, 1, "label 是对象，按 string 报失败");
        let unknown: Vec<&str> = info
            .unknown
            .iter()
            .map(|field| field.path.as_str())
            .collect();
        assert!(unknown.contains(&"meta"), "标准外的 meta 要进待收录");
        assert!(unknown.contains(&"meta.note"), "嵌套键也要走到");
        assert!(unknown.contains(&"label.zh"), "label 里的 zh 也要走到");
    }

    /// 报告四步轨迹都走到，结果挂在校准维。
    #[test]
    fn 报告四步都走到() {
        let standard = standard();
        let info = CalibratedInfo {
            files: 1,
            hits: 3,
            passed: 3,
            failed: 0,
            failures: Vec::new(),
            unknown: Vec::new(),
        };
        let report = build_report(&standard, "测试", info);
        assert_eq!(report.trace.len(), 4);
        assert!(
            report
                .trace
                .iter()
                .all(|step| step.status == StepStatus::Done)
        );
        let calibrated = report.results.calibrated.as_ref().expect("校准维在");
        assert_eq!(calibrated.passed, 3);
        assert!(report.results.loaded.is_none());
        assert!(report.pending.is_none());
    }

    /// uuid 形状函数本体。
    #[test]
    fn uuid形状判得准() {
        assert!(is_uuid("550e8400-e29b-41d4-a716-446655440000"));
        assert!(!is_uuid("550e8400e29b41d4a716446655440000"));
        assert!(!is_uuid("550e8400-e29b-41d4-a716-44665544000g"));
    }
}
