//! 范畴间两个操作共用的底座 —— 流程骨架、报告骨架、变更请求与三张表的读取。
//!
//! 融合型（unify）与将来的对接型（interface）走同一条五步：选定 → 映射 →
//! 冲突 → 缺失 → 结论。这一步一步怎么落成报告、缺规则时怎么停、表从哪里读，
//! 在这里；每一步具体怎么说、映射是什么语义、冲突怎么判、结论是什么，由各操作
//! 自己给（见 [`Narration`]）。
//!
//! 本体表与映射表都只读不写：表里没有的规则不代拟，缺规则时生成 change_request
//! 停在原地等人填——这是停机位，不是错误。

use serde::de::DeserializeOwned;
use std::path::PathBuf;

use super::super::common::{Report, Results, Step, StepStatus, render_json, render_markdown};
use super::super::within::{self, OntologyDef};

// ───────────────────────── 表从哪读 ─────────────────────────

/// 装进二进制的映射表：`<源>--<目标>` → `examples/between/<源>--<目标>.yaml` 的内容。
///
/// 与本体表同理：`CARGO_MANIFEST_DIR` 是构建期的源码目录，装完的二进制去找不到它。
const MAPPINGS: &[(&str, &str)] = &[
    (
        "qtcloud-code-cli--qtcloud-work-cli",
        include_str!("../../../examples/between/qtcloud-code-cli--qtcloud-work-cli.yaml"),
    ),
    (
        "qtcloud-work-cli--qtcloud-meta-cli-category",
        include_str!("../../../examples/between/qtcloud-work-cli--qtcloud-meta-cli-category.yaml"),
    ),
    (
        "qtcloud-meta-cli-category--qtcloud-code-cli",
        include_str!("../../../examples/between/qtcloud-meta-cli-category--qtcloud-code-cli.yaml"),
    ),
];

/// 映射表的键：`<源>--<目标>`，哪一对范畴由键决定，表里不写。
pub fn mapping_key(from: &str, to: &str) -> String {
    format!("{from}--{to}")
}

/// 取一张 YAML 表。键不在表里视为「没有规则」，返回 `None`，不是错误。
///
/// `label` 只用于报错措辞（映射表、函子表……），读取机制各操作共用。
pub fn load_table<T: DeserializeOwned + 'static>(
    key: &str,
    label: &str,
) -> Result<Option<T>, String> {
    let Some(text) = MAPPINGS
        .iter()
        .find(|(k, _)| *k == key)
        .map(|(_, text)| text)
    else {
        return Ok(None);
    };
    let table: T = serde_yml::from_str(text).map_err(|e| format!("{label}表解析失败：{e}"))?;
    Ok(Some(table))
}

/// 按范畴标识装载本体。表里没有返回 `Ok(None)`——范畴未注册。
pub fn registered(category: &str) -> Result<Option<OntologyDef>, String> {
    if !within::has_ontology(category) {
        return Ok(None);
    }
    within::load_ontology(category).map(Some)
}

/// 本体承诺：这个范畴承认哪些对象。直接取概念名。
pub fn commitment_of(onto: &OntologyDef) -> String {
    let names: Vec<&str> = onto.concepts.iter().map(|c| c.name.as_str()).collect();
    if names.is_empty() {
        "未声明".to_string()
    } else {
        names.join("、")
    }
}

// ───────────────────────── 报告骨架 ─────────────────────────

/// CLI 选项。范畴间只给 format 与 out，不给 strict。
pub struct Options {
    pub format: String,
    pub out: Option<PathBuf>,
}

/// change_request 编号：`cr-map-<源范畴名>-<目标范畴名>`。
pub fn change_request_id(from_name: &str, to_name: &str) -> String {
    format!("cr-map-{from_name}-{to_name}")
}

/// 五步骨架里由各操作自己给的部分：第 2、3、5 步怎么说、结论是什么、结果维度有什么。
///
/// 第 1 步「选定范畴」与第 4 步「规则缺失」的骨架由 [`assemble_report`] 统一负责。
pub struct Narration {
    /// 第 2 步「映射翻译」的一句话；规则缺失时，这里就是缺失说明。
    pub mapping: String,
    /// `Some` 表示没有规则可用，停在第 4 步生成 change_request。
    pub missing: Option<String>,
    /// 第 3 步「冲突检查」的一句话（规则齐备时用）。
    pub conflict: String,
    /// 第 5 步「输出结论」的一句话（规则齐备时用）。
    pub conclusion_note: String,
    /// 结论正文（规则齐备时用）。
    pub conclusion: Vec<String>,
    /// 结果维度（规则齐备时用）。
    pub results: Results,
}

/// 未注册范畴的停机报告：第 1 步写明「未注册，停」，其余四步未走到。
pub fn unregistered_report(from_label: &str, to_label: &str, name: &str) -> Report {
    let mut trace = vec![Step {
        name: "选定范畴".to_string(),
        status: StepStatus::Done,
        note: Some(format!("{name} 未注册，停")),
    }];
    for step_name in ["映射翻译", "冲突检查", "规则缺失", "输出结论"] {
        trace.push(Step {
            name: step_name.to_string(),
            status: StepStatus::Skipped,
            note: None,
        });
    }
    Report {
        category: format!("{from_label} → {to_label}"),
        from: Some(from_label.to_string()),
        to: Some(to_label.to_string()),
        source: None,
        trace,
        results: Results {
            loaded: None,
            analyzed: None,
            translation: None,
        },
        relations: Vec::new(),
        conclusion: Vec::new(),
        pending: None,
    }
}

/// 装配五步报告。缺规则时停在第 4 步并挂起，不返回错误。
pub fn assemble_report(
    from_name: &str,
    to_name: &str,
    commitment: &str,
    narration: Narration,
) -> Report {
    // 过程轨迹固定五步：走到的是 Done，没走到的是 Skipped，停机位（规则缺失）是 Pending。
    let mut trace: Vec<Step> = vec![Step {
        name: "选定范畴".to_string(),
        status: StepStatus::Done,
        note: Some(format!("{from_name}，本体承诺 {commitment}")),
    }];

    if let Some(detail) = narration.missing {
        // 第 4 步：规则缺失。停机位，等人类定义规则，不往下走。
        let change_request = change_request_id(from_name, to_name);
        trace.push(Step {
            name: "映射翻译".to_string(),
            status: StepStatus::Done,
            note: Some(detail),
        });
        trace.push(Step {
            name: "冲突检查".to_string(),
            status: StepStatus::Skipped,
            note: None,
        });
        trace.push(Step {
            name: "规则缺失".to_string(),
            status: StepStatus::Pending,
            note: Some(format!(
                "生成 change_request {change_request}，分析暂停在当前范畴"
            )),
        });
        trace.push(Step {
            name: "输出结论".to_string(),
            status: StepStatus::Skipped,
            note: None,
        });

        return Report {
            category: format!("{from_name} → {to_name}"),
            from: Some(from_name.to_string()),
            to: Some(to_name.to_string()),
            source: None,
            trace,
            results: Results {
                loaded: None,
                analyzed: None,
                translation: None,
            },
            relations: Vec::new(),
            conclusion: Vec::new(),
            pending: Some(change_request),
        };
    }

    trace.push(Step {
        name: "映射翻译".to_string(),
        status: StepStatus::Done,
        note: Some(narration.mapping),
    });
    trace.push(Step {
        name: "冲突检查".to_string(),
        status: StepStatus::Done,
        note: Some(narration.conflict),
    });
    trace.push(Step {
        name: "规则缺失".to_string(),
        status: StepStatus::Skipped,
        note: None,
    });
    trace.push(Step {
        name: "输出结论".to_string(),
        status: StepStatus::Done,
        note: Some(narration.conclusion_note),
    });

    Report {
        category: format!("{from_name} → {to_name}"),
        from: Some(from_name.to_string()),
        to: Some(to_name.to_string()),
        source: None,
        trace,
        results: narration.results,
        relations: Vec::new(),
        conclusion: narration.conclusion,
        pending: None,
    }
}

/// 按 format 渲染，写 `--out` 或打印到 stdout。
pub fn emit(report: &Report, options: &Options) -> Result<(), String> {
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

// ───────────────────────── 流程骨架 ─────────────────────────

/// 走完整条流程：校验格式 → 装载两端本体 → 各操作装配报告 → 渲染。
///
/// 未注册范畴写「未注册，停」并以错误退出；规则缺失是停机位，返回 `Ok(())`。
/// `assemble` 拿到两端的名字与源端承诺，按各操作自己的语义给出报告。
pub fn drive<F>(from: &str, to: &str, options: &Options, assemble: F) -> Result<(), String>
where
    F: FnOnce(&str, &str, &str) -> Result<Report, String>,
{
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

    let report = assemble(&from_onto.name, &to_onto.name, &commitment_of(&from_onto))?;
    emit(&report, options)
}
