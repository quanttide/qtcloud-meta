//! 范式内与范式间共用的报告结构 —— 对应 `docs/dev-guide/paradigm/common.md`。
//!
//! 报告有两个正交维度：
//!
//! - 过程维度 [`Step`]：走到了哪一步，状态 Done / Skipped / Pending。
//! - 结果维度 [`Results`]：产出了什么，装载、分析、翻译三个可选，谁有填谁。
//!
//! 两个模块各填各的：within 填 trace 的装载、分析两步与 results 的 loaded、
//! analyzed；between 填 trace 的五步与 results 的 translation。Markdown 与 JSON
//! 两个出口共用同一份 [`Report`]，不各算一遍。

use serde::Serialize;
use std::path::PathBuf;

use super::between::TranslationInfo;
use super::within::{AnalyzedInfo, LoadedInfo, RelationInfo};

// ───────────────────────── 表从哪读 ─────────────────────────

/// 向上查找的级数上限，防无限上溯。
const MAX_UP: usize = 8;

/// 从当前目录逐级向上找 `<子目录>/<文件名>`，找到返回完整路径。
///
/// 子目录形如 `examples/paradigm`、`examples/between`。文件优先、内置快照保底：
/// 仓库内跑读到的是正本，装完的二进制在任意目录运行时回落到打包时的快照。
pub fn find_table_file(subdir: &str, file: &str) -> Option<PathBuf> {
    let mut dir = std::env::current_dir().ok()?;
    for _ in 0..MAX_UP {
        let candidate = dir.join(subdir).join(file);
        if candidate.is_file() {
            return Some(candidate);
        }
        if !dir.pop() {
            break;
        }
    }
    None
}

/// 填表提示：找到表目录给完整路径，没找到给仓库内相对路径。
///
/// 停机位的回路就靠这句：人照着补完文件，复跑即接上。
pub fn fill_hint(subdir: &str, file: &str) -> String {
    match find_table_file(subdir, file) {
        Some(path) => format!("在 {} 补规则后复跑本命令即接上", path.display()),
        None => format!(
            "在仓库 {subdir}/{file} 新建并补规则后复跑本命令即接上（当前目录向上未找到表目录）"
        ),
    }
}

// ───────────────────────── 报告数据 ─────────────────────────

/// 过程维度：一步的状态。
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
pub enum StepStatus {
    /// 走到了。
    Done,
    /// 没走到。
    Skipped,
    /// 停机位，等人填规则。
    Pending,
}

/// 过程维度：一步的轨迹。
#[derive(Debug, Serialize)]
pub struct Step {
    /// 步骤名：装载 / 分析 / 选定范式 / 映射翻译 / 冲突检查 / 规则缺失 / 输出结论。
    pub name: String,
    pub status: StepStatus,
    /// 这一步发生了什么；没发生的步留空。
    #[serde(skip_serializing_if = "Option::is_none")]
    pub note: Option<String>,
}

/// 结果维度：三个可选，谁有填谁。
#[derive(Debug, Serialize)]
pub struct Results {
    #[serde(skip_serializing_if = "Option::is_none")]
    pub loaded: Option<LoadedInfo>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub analyzed: Option<AnalyzedInfo>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub translation: Option<Vec<TranslationInfo>>,
}

/// 一份报告：过程轨迹 + 结果，外加关系清单、结论、挂起项三个公共出口。
#[derive(Debug, Serialize)]
pub struct Report {
    /// 给人看的报告标题。范式内是范式名；范式间是「源 → 目标」。
    pub category: String,
    /// 范式间专用：源范式名与目标范式名的可机读形式；范式内留空。
    /// 之所以单列，是因为 `category` 在两侧含义不同，同一个键不该有两种意思。
    #[serde(skip_serializing_if = "Option::is_none")]
    pub from: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub to: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub source: Option<String>,
    pub trace: Vec<Step>,
    pub results: Results,
    pub relations: Vec<RelationInfo>,
    pub conclusion: Vec<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub pending: Option<String>,
}

// ───────────────────────── 渲染 ─────────────────────────

/// Markdown 出口；按 results 里有哪一维选版式，两个模块共用这一个出口。
pub fn render_markdown(report: &Report) -> String {
    if report.results.loaded.is_some() {
        render_within(report)
    } else {
        render_between(report)
    }
}

/// JSON 出口；与 Markdown 同源，序列化同一份 [`Report`]。
pub fn render_json(report: &Report) -> Result<String, String> {
    serde_json::to_string_pretty(report).map_err(|e| format!("JSON 序列化失败：{e}"))
}

/// 范式内版式：装载、分析、关系清单、给后续分析的结论。
fn render_within(report: &Report) -> String {
    let mut out = String::new();
    out.push_str(&format!("# 范式分析报告：{}\n\n", report.category));
    if let Some(source) = &report.source {
        out.push_str(&format!("数据源：{source}\n"));
    }
    out.push_str("方法：lau-category-theory 0.1.0 的范式构造、恒等、复合与公理校验\n");
    if let Some(note) = report.trace.first().and_then(|step| step.note.as_deref()) {
        out.push_str(&format!("{note}\n"));
    }
    out.push('\n');

    if let Some(loaded) = &report.results.loaded {
        out.push_str("## 装载\n");
        let names: Vec<&str> = loaded.objects.iter().map(|o| o.name.as_str()).collect();
        out.push_str(&format!(
            "- 对象 {} 个：{}\n",
            loaded.counts.objects,
            names.join("、")
        ));
        for object in &loaded.objects {
            if let Some(label) = object.label.get("zh") {
                out.push_str(&format!("  - {} = {}\n", object.name, label));
            }
        }
        out.push_str(&format!(
            "- 态射 {} 条 = 恒等 {} 条 + 声明 {} 条\n\n",
            loaded.counts.total_morphisms, loaded.counts.identities, loaded.counts.declared
        ));
    }

    if let Some(analyzed) = &report.results.analyzed {
        out.push_str("## 分析\n");
        for group in &analyzed.groups {
            out.push_str(&format!(
                "- {}：共 {} 条，通过 {}，失败 {}\n",
                group.label, group.total, group.passed, group.failed
            ));
            for failure in &group.failures {
                out.push_str(&format!("  - 失败：{failure}\n"));
            }
            if let Some(reason) = &group.reason {
                out.push_str(&format!("  - 原因：{reason}\n"));
            }
        }
        out.push_str(&format!(
            "- 可复合的态射对：{} 对\n",
            analyzed.composable_pairs
        ));
        out.push_str(&format!(
            "- 派生关系（复合得出且未声明）：{} 条\n",
            analyzed.derived.len()
        ));
        if let Some(reason) = &analyzed.derived_reason {
            out.push_str(&format!("  - 原因：{reason}\n"));
        }
    }

    out.push_str("\n## 关系清单\n");
    for relation in &report.relations {
        if relation.derived {
            out.push_str(&format!(
                "{} -[{}]-> {}（派生）\n",
                relation.from, relation.kind, relation.to
            ));
        } else {
            out.push_str(&format!(
                "{} -[{}]-> {}\n",
                relation.from, relation.kind, relation.to
            ));
        }
    }

    out.push_str("\n## 给后续分析的结论\n");
    for (index, line) in report.conclusion.iter().enumerate() {
        out.push_str(&format!("{}. {line}\n", index + 1));
    }
    out
}

/// 范式间版式：五步轨迹（跳过的步不列）+ 结论或挂起。
fn render_between(report: &Report) -> String {
    let mut out = String::new();
    out.push_str(&format!("# 范式间报告：{}\n", report.category));
    for (index, step) in report.trace.iter().enumerate() {
        if step.status == StepStatus::Skipped {
            continue;
        }
        out.push_str(&format!(
            "- {} {}：{}\n",
            index + 1,
            step.name,
            step.note.as_deref().unwrap_or("")
        ));
    }
    match &report.pending {
        Some(change_request) => {
            out.push_str(&format!("- 挂起：{change_request} 等人类定义规则\n"));
        }
        None if !report.conclusion.is_empty() => {
            out.push_str(&format!("- 结论：{}\n", report.conclusion.join("；")));
        }
        None => {}
    }
    out
}
