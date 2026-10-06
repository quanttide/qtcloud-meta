//! 元本体是活文档，不是死注释——这个测试守着它别烂掉。
//!
//! 本体是 `examples/ontology/category.yaml`（工具描述自己所在的范畴），
//! 定性见 `docs/dev-guide/category/meta-ontology.md`。两件检查：
//!
//! 1. **对齐**：本体声明里声明的概念，必须能在 `src/category/within.rs` 找到同名类型——
//!    改了代码（改名、删类型）却没改本体，这里红。
//! 2. **快照**：报告的关键数字与期望值一致——合法变更也在这里留痕，红了就说明本体该更新。

use qtcloud_meta_cli::category::within;
use std::collections::BTreeSet;
use std::path::Path;

/// 扫出 `src/category/within.rs` 里所有 `pub struct` / `pub enum` 的名字。
fn code_type_names() -> BTreeSet<String> {
    let path = Path::new(env!("CARGO_MANIFEST_DIR")).join("src/category/within.rs");
    let source = std::fs::read_to_string(&path).expect("读不到 within.rs");
    source
        .lines()
        .filter_map(|line| {
            let line = line.trim();
            for prefix in ["pub struct ", "pub enum "] {
                if let Some(rest) = line.strip_prefix(prefix) {
                    let name = rest
                        .split(|c: char| !(c.is_alphanumeric() || c == '_'))
                        .next()
                        .unwrap_or("");
                    return Some(name.to_string());
                }
            }
            None
        })
        .filter(|name| !name.is_empty())
        .collect()
}

#[test]
fn concepts_exist_in_code() {
    let ontology = within::load_ontology("category").expect("读不到本体");
    let names = code_type_names();
    let missing: Vec<&String> = ontology
        .concepts
        .iter()
        .map(|concept| &concept.name)
        .filter(|name| !names.contains(*name))
        .collect();
    assert!(
        missing.is_empty(),
        "本体里这些概念在 src/category/within.rs 找不到同名类型——代码改了，本体没跟上：{missing:?}\n\n代码里现有：{names:?}"
    );
}

#[test]
fn report_snapshot() {
    let ontology = within::load_ontology("category").expect("读不到本体");
    let category = within::build_category(&ontology);
    let report = within::build_report(&ontology, &category);

    assert_eq!(
        report.loaded.counts.objects, 9,
        "对象数变了——本体或代码改了，快照要跟着更新"
    );
    assert_eq!(report.loaded.counts.declared, 7, "声明态射数变了");
    assert_eq!(report.loaded.counts.identities, 9, "恒等态射数变了");
    assert_eq!(report.analyzed.composable_pairs, 1, "可复合的态射对数变了");
    assert_eq!(report.analyzed.derived.len(), 1, "派生关系数变了");

    let groups: Vec<(&str, usize, usize, usize)> = report
        .analyzed
        .groups
        .iter()
        .map(|group| {
            (
                group.label.as_str(),
                group.total,
                group.passed,
                group.failed,
            )
        })
        .collect();
    assert_eq!(
        groups,
        vec![
            ("范畴定律", 2, 2, 0),
            ("结构公理", 0, 0, 0),
            ("领域公理", 2, 2, 0),
        ],
        "各公理组的数字变了——本体或代码改了，快照要跟着更新"
    );
}
