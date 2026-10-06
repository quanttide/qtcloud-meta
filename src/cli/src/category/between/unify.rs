//! 范畴间·融合型：五步走 —— 对应 `docs/user-guide/category/between.md`。
//!
//! 流程：选定范畴 → 映射翻译 → 冲突检查 → 规则缺失 → 输出结论。
//! 只查表（本体、映射表、冲突表），表里没有的规则不代拟；缺规则时生成
//! change_request，停在原地等人填——这是停机位，不是错误。
//!
//! 步骤框架、报告骨架、变更请求与三张表的读取在 [`super::common`]；这里只留融合型
//! 自己的语义：映射是重命名（源概念 → 目标概念）、冲突看 `true_conflict`、结论是
//! 翻译清单。报告走 [`super::super::common::Report`]，Markdown 与 JSON 两个出口
//! 共用同一份，不各算一遍。

use serde::{Deserialize, Serialize};

use super::super::common::{Report, Results};
use super::common::{Narration, drive, load_table};
pub use super::common::{Options, mapping_path};

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
//
// 报告外壳（Report / Results / Step）在 [`super::super::common`]；这里只放翻译结果类型。

/// 一条翻译结论：源概念 → 目标概念。
#[derive(Debug, Serialize)]
pub struct TranslationInfo {
    pub from: String,
    pub to: String,
}

// ───────────────────────── 装载 ─────────────────────────

/// 读映射表。文件不存在视为「没有映射规则」，返回 `None`，不是错误。
pub fn load_mapping(from: &str, to: &str) -> Result<Option<BetweenDef>, String> {
    load_table(&mapping_path(from, to), "映射")
}

// ───────────────────────── 五步 ─────────────────────────

/// 走上五步，装配报告。缺规则时停在第 4 步并挂起，不返回错误。
pub fn build_report(
    from_name: &str,
    to_name: &str,
    commitment: &str,
    table: Option<&BetweenDef>,
) -> Report {
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
        return super::common::assemble_report(
            from_name,
            to_name,
            commitment,
            Narration {
                mapping: detail.clone(),
                missing: Some(detail),
                conflict: String::new(),
                conclusion_note: String::new(),
                conclusion: Vec::new(),
                results: Results {
                    loaded: None,
                    analyzed: None,
                    translation: None,
                },
            },
        );
    }

    // 第 3 步：冲突检查。只认 true_conflict；其它类型忽略、继续。
    let true_conflict = table.and_then(|t| {
        t.conflicts
            .iter()
            .find(|c| c.conflict_type == "true_conflict")
    });
    let conflict_note = match true_conflict {
        Some(conflict) => {
            let resolution = conflict
                .resolution
                .clone()
                .unwrap_or_else(|| "（未写裁决内容）".to_string());
            format!("命中 true_conflict，按既往裁决处理：{resolution}")
        }
        None => "无 true_conflict 记录，按主文档继续".to_string(),
    };

    // 第 5 步：输出结论
    let translation: Vec<TranslationInfo> = mappings
        .iter()
        .map(|m| TranslationInfo {
            from: m.from.clone(),
            to: m.to.clone(),
        })
        .collect();
    let conclusion: Vec<String> = translation
        .iter()
        .map(|t| format!("{} → {}", t.from, t.to))
        .collect();

    super::common::assemble_report(
        from_name,
        to_name,
        commitment,
        Narration {
            mapping: format!("查到 {} 条规则", mappings.len()),
            missing: None,
            conflict: conflict_note,
            conclusion_note: format!("{} 条断言翻到「{to_name}」", translation.len()),
            conclusion,
            results: Results {
                loaded: None,
                analyzed: None,
                translation: Some(translation),
            },
        },
    )
}

// ───────────────────────── CLI 入口 ─────────────────────────

/// 执行 `category between`：选定 → 映射 → 冲突 → 缺失 → 结论。
///
/// 未注册范畴写「未注册，停」并以错误退出；规则缺失是停机位，返回 `Ok(())`。
pub fn run(from: &str, to: &str, options: &Options) -> Result<(), String> {
    drive(from, to, options, |from_name, to_name, commitment| {
        let table = load_mapping(from, to)?;
        Ok(build_report(from_name, to_name, commitment, table.as_ref()))
    })
}
