//! 范畴间：五步走 —— 对应 `docs/user-guide/category/between.md`。
//!
//! 流程：选定范畴 → 映射翻译 → 冲突检查 → 规则缺失 → 输出结论。
//! 只查表（本体、映射表、冲突表），表里没有的规则不代拟；缺规则时生成
//! change_request，停在原地等人填——这是停机位，不是错误。
//!
//! 底座复用 [`super::within::load_ontology`] 装载本体；Markdown 与 JSON
//! 两个出口共用同一份 [`Report`]，不各算一遍。

use serde::{Deserialize, Serialize};
use std::path::{Path, PathBuf};

use super::within::{self, OntologyDef};

// ───────────────────────── YAML 映射/冲突 schema ─────────────────────────

/// 范畴间映射文件，对应 `examples/between/<源>--<目标>.yaml`。
///
/// 文件只放两张表：映射表与冲突表；哪一对范畴由文件名决定。
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BetweenDef {
    #[serde(default)]
    pub mappings: Vec<MappingDef>,
    #[serde(default)]
    pub conflicts: Vec<ConflictDef>,
}

/// 一条映射规则：源概念 → 目标概念。缺目标即「断言没有对应规则」。
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct MappingDef {
    #[serde(default)]
    pub from: String,
    #[serde(default)]
    pub to: String,
}

/// 一条冲突记录。只认 `true_conflict`，其它类型忽略、继续。
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConflictDef {
    #[serde(rename = "type")]
    pub conflict_type: String,
    #[serde(default)]
    pub from: Option<String>,
    #[serde(default)]
    pub to: Option<String>,
    /// 既往人类裁决内容；命中 true_conflict 时写进报告。
    #[serde(default)]
    pub resolution: Option<String>,
}

// ───────────────────────── 报告数据 ─────────────────────────

/// 一份范畴间报告：走的步、翻出的结论、挂起的变更请求。
#[derive(Debug, Serialize)]
pub struct Report {
    pub from: String,
    pub to: String,
    pub steps: Vec<StepInfo>,
    pub conclusion: Vec<TranslationInfo>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub pending: Option<String>,
}

/// 一步：编号、名称、一句话说明。
#[derive(Debug, Serialize)]
pub struct StepInfo {
    pub step: u8,
    pub label: String,
    pub detail: String,
}

/// 一条翻译结论：源概念 → 目标概念。
#[derive(Debug, Serialize)]
pub struct TranslationInfo {
    pub from: String,
    pub to: String,
}

/// CLI 选项。范畴间只给 format 与 out，不给 strict。
pub struct Options {
    pub format: String,
    pub out: Option<PathBuf>,
}

// ───────────────────────── 装载 ─────────────────────────

/// 映射文件路径：`examples/between/<源>--<目标>.yaml`。
///
/// 映射表是示例数据，归 `examples/`；`src/` 下只放实现。
pub fn mapping_path(from: &str, to: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("examples")
        .join("between")
        .join(format!("{from}--{to}.yaml"))
}

/// 读映射表。文件不存在视为「没有映射规则」，返回 `None`，不是错误。
pub fn load_mapping(from: &str, to: &str) -> Result<Option<BetweenDef>, String> {
    let path = mapping_path(from, to);
    if !path.exists() {
        return Ok(None);
    }
    let text = std::fs::read_to_string(&path)
        .map_err(|e| format!("读不到映射文件 {}：{e}", path.display()))?;
    let table: BetweenDef = serde_yml::from_str(&text)
        .map_err(|e| format!("映射文件 {} 解析失败：{e}", path.display()))?;
    Ok(Some(table))
}

/// 按范畴标识装载本体。文件不存在返回 `Ok(None)`——范畴未注册。
fn registered(category: &str) -> Result<Option<OntologyDef>, String> {
    if !within::ontology_path(category).exists() {
        return Ok(None);
    }
    within::load_ontology(category).map(Some)
}

/// 本体承诺：这个范畴承认哪些对象。直接取概念名。
fn commitment_of(onto: &OntologyDef) -> String {
    let names: Vec<&str> = onto.concepts.iter().map(|c| c.name.as_str()).collect();
    if names.is_empty() {
        "未声明".to_string()
    } else {
        names.join("、")
    }
}

// ───────────────────────── 五步 ─────────────────────────

/// change_request 编号：`cr-map-<源范畴名>-<目标范畴名>`。
fn change_request_id(from_name: &str, to_name: &str) -> String {
    format!("cr-map-{from_name}-{to_name}")
}

/// 未注册范畴的停机报告：只有第 1 步，写明「未注册，停」。
fn unregistered_report(from_label: &str, to_label: &str, name: &str) -> Report {
    Report {
        from: from_label.to_string(),
        to: to_label.to_string(),
        steps: vec![StepInfo {
            step: 1,
            label: "选定范畴".to_string(),
            detail: format!("{name} 未注册，停"),
        }],
        conclusion: Vec::new(),
        pending: None,
    }
}

/// 走上五步，装配报告。缺规则时停在第 4 步并挂起，不返回错误。
pub fn build_report(
    from_name: &str,
    to_name: &str,
    commitment: &str,
    table: Option<&BetweenDef>,
) -> Report {
    let mut steps: Vec<StepInfo> = Vec::new();

    // 第 1 步：选定范畴
    steps.push(StepInfo {
        step: 1,
        label: "选定范畴".to_string(),
        detail: format!("{from_name}，本体承诺 {commitment}"),
    });

    let mappings: &[MappingDef] = table.map(|t| t.mappings.as_slice()).unwrap_or(&[]);

    // 第 2 步：映射翻译。没有规则，或某条断言没有对应规则，都进第 4 步。
    let missing = if mappings.is_empty() {
        Some(format!("{from_name} → {to_name} 没有映射规则"))
    } else {
        mappings
            .iter()
            .find(|m| m.to.trim().is_empty())
            .map(|m| format!("断言『{}』没有对应规则", m.from))
    };

    if let Some(detail) = missing {
        steps.push(StepInfo {
            step: 2,
            label: "映射翻译".to_string(),
            detail,
        });

        // 第 4 步：规则缺失。停机位，等人类定义规则，不往下走。
        let change_request = change_request_id(from_name, to_name);
        steps.push(StepInfo {
            step: 4,
            label: "规则缺失".to_string(),
            detail: format!("生成 change_request {change_request}，分析暂停在当前范畴"),
        });

        return Report {
            from: from_name.to_string(),
            to: to_name.to_string(),
            steps,
            conclusion: Vec::new(),
            pending: Some(change_request),
        };
    }

    steps.push(StepInfo {
        step: 2,
        label: "映射翻译".to_string(),
        detail: format!("查到 {} 条规则", mappings.len()),
    });

    // 第 3 步：冲突检查。只认 true_conflict；其它类型忽略、继续。
    let true_conflict = table.and_then(|t| {
        t.conflicts
            .iter()
            .find(|c| c.conflict_type == "true_conflict")
    });
    match true_conflict {
        Some(conflict) => {
            let resolution = conflict
                .resolution
                .clone()
                .unwrap_or_else(|| "（未写裁决内容）".to_string());
            steps.push(StepInfo {
                step: 3,
                label: "冲突检查".to_string(),
                detail: format!("命中 true_conflict，按既往裁决处理：{resolution}"),
            });
        }
        None => {
            steps.push(StepInfo {
                step: 3,
                label: "冲突检查".to_string(),
                detail: "无 true_conflict 记录，按主文档继续".to_string(),
            });
        }
    }

    // 第 5 步：输出结论
    let conclusion: Vec<TranslationInfo> = mappings
        .iter()
        .map(|m| TranslationInfo {
            from: m.from.clone(),
            to: m.to.clone(),
        })
        .collect();
    steps.push(StepInfo {
        step: 5,
        label: "输出结论".to_string(),
        detail: format!("{} 条断言翻到「{to_name}」", conclusion.len()),
    });

    Report {
        from: from_name.to_string(),
        to: to_name.to_string(),
        steps,
        conclusion,
        pending: None,
    }
}

// ───────────────────────── 渲染 ─────────────────────────

/// Markdown 出口。
pub fn render_markdown(report: &Report) -> String {
    let mut out = String::new();
    out.push_str(&format!("# 范畴间报告：{} → {}\n", report.from, report.to));
    for step in &report.steps {
        out.push_str(&format!(
            "- {} {}：{}\n",
            step.step, step.label, step.detail
        ));
    }
    match &report.pending {
        Some(change_request) => {
            out.push_str(&format!("- 挂起：{change_request} 等人类定义规则\n"));
        }
        None if !report.conclusion.is_empty() => {
            let pairs: Vec<String> = report
                .conclusion
                .iter()
                .map(|t| format!("{} → {}", t.from, t.to))
                .collect();
            out.push_str(&format!("- 结论：{}\n", pairs.join("；")));
        }
        None => {}
    }
    out
}

/// JSON 出口；与 Markdown 同源，序列化同一份 [`Report`]。
pub fn render_json(report: &Report) -> Result<String, String> {
    serde_json::to_string_pretty(report).map_err(|e| format!("JSON 序列化失败：{e}"))
}

// ───────────────────────── CLI 入口 ─────────────────────────

/// 执行 `category between`：选定 → 映射 → 冲突 → 缺失 → 结论。
///
/// 未注册范畴写「未注册，停」并以错误退出；规则缺失是停机位，返回 `Ok(())`。
pub fn run(from: &str, to: &str, options: &Options) -> Result<(), String> {
    match options.format.as_str() {
        "md" | "json" => {}
        other => return Err(format!("未知输出格式 {other}，只支持 md 或 json")),
    }

    let Some(from_onto) = registered(from)? else {
        let report = unregistered_report(from, to, from);
        emit(&report, options)?;
        return Err(format!("范畴「{from}」未注册，停"));
    };
    let Some(to_onto) = registered(to)? else {
        let report = unregistered_report(&from_onto.name, to, to);
        emit(&report, options)?;
        return Err(format!("范畴「{to}」未注册，停"));
    };

    let table = load_mapping(from, to)?;
    let report = build_report(
        &from_onto.name,
        &to_onto.name,
        &commitment_of(&from_onto),
        table.as_ref(),
    );
    emit(&report, options)
}

/// 按 format 渲染，写 `--out` 或打印到 stdout。
fn emit(report: &Report, options: &Options) -> Result<(), String> {
    let text = match options.format.as_str() {
        "json" => format!("{}\n", render_json(report)?),
        _ => render_markdown(report),
    };
    match &options.out {
        Some(path) => {
            std::fs::write(path, text).map_err(|e| format!("写入 {} 失败：{e}", path.display()))
        }
        None => {
            print!("{text}");
            Ok(())
        }
    }
}
