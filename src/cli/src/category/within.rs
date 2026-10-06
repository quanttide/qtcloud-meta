//! 范畴内：装载与分析 —— 对应 `docs/user-guide/category/within.md`。
//!
//! 流程：YAML 本体 → serde 解析 → lau-category-theory 构造范畴 →
//! 分析引擎（范畴定律 / 结构公理 / 领域公理 / 复合与派生）→ 报告渲染。
//!
//! 底座是 lau-category-theory 0.1.0（MIT），替换原 pr4xis
//! （CC-BY-NC-SA-4.0，禁商用）。报告走 [`super::common::Report`]，Markdown 与
//! JSON 两个出口共用同一份，不各算一遍。

use lau_category_theory::category::{FiniteCategory, Morphism, Obj};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::path::PathBuf;

use super::common::{Report, Results, Step, StepStatus, render_json, render_markdown};

/// 结构公理只对这四类规范关系种类发布，别的种类不发布。
const STRUCTURAL_KINDS: [&str; 4] = ["Subsumption", "Parthood", "Causation", "Opposition"];

// ───────────────────────── YAML 本体 schema ─────────────────────────

/// 本体定义，schema 见 `docs/dev-guide/category/within.md`。
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OntologyDef {
    pub name: String,
    #[serde(default)]
    pub source: Option<String>,
    #[serde(default)]
    pub version: Option<String>,
    pub concepts: Vec<ConceptDef>,
    pub edges: Vec<EdgeDef>,
    #[serde(default)]
    pub axioms: Vec<AxiomDef>,
}

/// 概念（对象）。
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConceptDef {
    pub name: String,
    #[serde(default)]
    pub label: HashMap<String, String>,
}

/// 边（态射）：从 from 到 to 的一条 kind 关系。
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EdgeDef {
    pub from: String,
    pub to: String,
    pub kind: String,
}

/// 领域公理（本体自己声明的业务规则）。
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AxiomDef {
    pub id: String,
    pub description: String,
    #[serde(rename = "type")]
    pub axiom_type: String,
    pub target: String,
    pub relation: String,
    pub constraint: String,
}

// ───────────────────────── 报告数据 ─────────────────────────
//
// 报告外壳（Report / Results / Step）在 [`super::common`]；这里只放装载与分析的
// 结果类型，结构保持不变。

/// 装载结果。
#[derive(Debug, Serialize)]
pub struct LoadedInfo {
    pub objects: Vec<ObjectInfo>,
    pub morphisms: Vec<MorphismInfo>,
    pub counts: Counts,
}

/// 对象及其标签。
#[derive(Debug, Serialize)]
pub struct ObjectInfo {
    pub name: String,
    pub label: HashMap<String, String>,
}

/// 一条声明的关系。
#[derive(Debug, Serialize)]
pub struct MorphismInfo {
    pub kind: String,
    pub from: String,
    pub to: String,
}

/// 计数。
#[derive(Debug, Serialize)]
pub struct Counts {
    pub objects: usize,
    pub declared: usize,
    pub identities: usize,
    pub total_morphisms: usize,
}

/// 分析结果。
#[derive(Debug, Serialize)]
pub struct AnalyzedInfo {
    pub groups: Vec<LawGroup>,
    pub composable_pairs: usize,
    pub derived: Vec<MorphismInfo>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub derived_reason: Option<String>,
}

/// 一组公理的校验结果；为 0 时用 `reason` 说明原因。
#[derive(Debug, Serialize)]
pub struct LawGroup {
    pub label: String,
    pub total: usize,
    pub passed: usize,
    pub failed: usize,
    pub failures: Vec<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub reason: Option<String>,
}

/// 关系清单里的一行。
#[derive(Debug, Serialize)]
pub struct RelationInfo {
    pub from: String,
    pub kind: String,
    pub to: String,
    pub derived: bool,
}

/// CLI 选项。
pub struct Options {
    pub format: String,
    pub out: Option<PathBuf>,
    pub strict: bool,
}

// ───────────────────────── 装载 ─────────────────────────

/// 装进二进制的本体表：范畴标识 → `examples/category/<标识>.yaml` 的内容。
///
/// 源文件仍归 `examples/`，`src/` 下只放实现；这里在编译期读进来，
/// 因为 `CARGO_MANIFEST_DIR` 指向的是构建期的源码目录——从 crates.io 装下来的
/// 二进制既没有那个目录，也没有那份文件。
const ONTOLOGIES: &[(&str, &str)] = &[
    (
        "qtcloud-meta-cli-category",
        include_str!("../../examples/category/qtcloud-meta-cli-category.yaml"),
    ),
    (
        "qtcloud-code-cli",
        include_str!("../../examples/category/qtcloud-code-cli.yaml"),
    ),
    (
        "qtcloud-work-cli",
        include_str!("../../examples/category/qtcloud-work-cli.yaml"),
    ),
];

/// 范畴是否已注册（本体表里有没有这一项）。
pub fn has_ontology(category: &str) -> bool {
    ONTOLOGIES.iter().any(|(id, _)| *id == category)
}

/// 读并解析本体。范畴不在表里按错误返回，不做容错降级。
pub fn load_ontology(category: &str) -> Result<OntologyDef, String> {
    let text = ONTOLOGIES
        .iter()
        .find(|(id, _)| *id == category)
        .map(|(_, text)| *text)
        .ok_or_else(|| format!("范畴「{category}」未注册，本体表里没有这一项"))?;
    let onto: OntologyDef =
        serde_yml::from_str(text).map_err(|e| format!("范畴「{category}」的本体解析失败：{e}"))?;
    validate_ontology(&onto)?;
    Ok(onto)
}

/// 边引用的概念必须在 concepts 里。
fn validate_ontology(onto: &OntologyDef) -> Result<(), String> {
    for edge in &onto.edges {
        if !onto.concepts.iter().any(|c| c.name == edge.from) {
            return Err(format!(
                "边 {} 的起点 {} 不在 concepts 里",
                edge.kind, edge.from
            ));
        }
        if !onto.concepts.iter().any(|c| c.name == edge.to) {
            return Err(format!(
                "边 {} 的终点 {} 不在 concepts 里",
                edge.kind, edge.to
            ));
        }
    }
    Ok(())
}

// ───────────────────────── 构造范畴 ─────────────────────────

/// 边 → 态射的唯一名字：种类 + 端点，避免同名种类互相顶掉。
fn edge_morphism_name(kind: &str, from: &str, to: &str) -> String {
    format!("{kind}#{from}->{to}")
}

/// 从态射名字里取回关系种类。
fn kind_of(m: &Morphism) -> String {
    m.name
        .split('#')
        .next()
        .unwrap_or(m.name.as_str())
        .to_string()
}

/// 恒等态射由 `FiniteCategory::new` 自动加，名字是 `id_<对象>`。
fn is_identity(m: &Morphism) -> bool {
    m.dom == m.cod && m.name == format!("id_{}", m.dom.0)
}

/// 复合表里的一条：`kinds` 按 dom→cod 顺序记路径上的关系种类。
///
/// 名字只由**路径本身**决定、不带括号——库按名字判等，同一个路径怎么打括号都得同一个名字。
struct Composite {
    name: String,
    dom: Obj,
    cod: Obj,
    kinds: Vec<String>,
}

/// 路径名：关系种类序列（反序，读起来就是 dom→cod）+ 端点。
fn composite_name(kinds: &[String], dom: &Obj, cod: &Obj) -> String {
    let display: Vec<String> = kinds.iter().rev().cloned().collect();
    format!("{}#{}->{}", display.join("∘"), dom.0, cod.0)
}

/// `outer ∘ inner`（要求 `outer.dom == inner.cod`）接出的一条路径。
fn compose_paths(outer: &Composite, inner: &Composite) -> Composite {
    // 路径按 dom→cod 排：内段在前、外段在后。
    let mut kinds = inner.kinds.clone();
    kinds.extend(outer.kinds.iter().cloned());
    Composite {
        name: composite_name(&kinds, &inner.dom, &outer.cod),
        dom: inner.dom.clone(),
        cod: outer.cod.clone(),
        kinds,
    }
}

/// 把一条合成写进表（`first ∘ second`，要求 `first.dom == second.cod`）。
fn put_composition(
    cat: &mut FiniteCategory,
    first: &Composite,
    second: &Composite,
    result: &Composite,
) {
    let first = Morphism::new(first.name.clone(), first.dom.clone(), first.cod.clone());
    let second = Morphism::new(second.name.clone(), second.dom.clone(), second.cod.clone());
    let result = Morphism::new(result.name.clone(), result.dom.clone(), result.cod.clone());
    cat.set_composition(&first, &second, &result);
}

/// 概念 → 对象，边 → 态射，并为「声明边的三连复合」把合成表建齐。
///
/// 表只建到长度 3。理由：库的 `check_associativity` 遍历的三元组全部取自
/// `cat.morphisms`（对象恒等 + 声明边），它查表只有四种形态——`compose(声明, 声明)`
/// 两次（`f∘g` 与 `g∘h`）与 `compose(长度2, 声明)`、`compose(声明, 长度2)`；
/// 长度 3 的合成结果只被拿去比名字，不会再作为键去查表。原实现一路建到全闭包
/// （合成再合成），遇到自环或平行边时组合数失控、内存爆掉，而那一层三元组检查根本用不到。
pub fn build_category(onto: &OntologyDef) -> FiniteCategory {
    let objects: Vec<Obj> = onto
        .concepts
        .iter()
        .map(|c| Obj::new(c.name.clone()))
        .collect();
    let mut cat = FiniteCategory::new(onto.name.clone(), objects);

    for edge in &onto.edges {
        let dom = Obj::new(edge.from.clone());
        let cod = Obj::new(edge.to.clone());
        cat.add_morphism(
            edge_morphism_name(&edge.kind, &edge.from, &edge.to),
            &dom,
            &cod,
        );
    }

    let declared: Vec<Composite> = cat
        .morphisms
        .iter()
        .filter(|m| !is_identity(m))
        .map(|m| Composite {
            name: m.name.clone(),
            dom: m.dom.clone(),
            cod: m.cod.clone(),
            kinds: vec![kind_of(m)],
        })
        .collect();

    // 长度 2：声明边两两首尾相接。顺带写 `compose(声明, 声明)` 的表项。
    let mut pairs: Vec<Composite> = Vec::new();
    for outer in &declared {
        for inner in &declared {
            if outer.dom != inner.cod {
                continue;
            }
            let composed = compose_paths(outer, inner);
            put_composition(&mut cat, outer, inner, &composed);
            pairs.push(composed);
        }
    }

    // 长度 3：三元组检查另两个查表点——`compose(长度2, 声明)` 与 `compose(声明, 长度2)`。
    for pair in &pairs {
        for edge in &declared {
            if pair.dom == edge.cod {
                let composed = compose_paths(pair, edge);
                put_composition(&mut cat, pair, edge, &composed);
            }
            if edge.dom == pair.cod {
                let composed = compose_paths(edge, pair);
                put_composition(&mut cat, edge, pair, &composed);
            }
        }
    }

    cat
}

// ───────────────────────── 分析 ─────────────────────────

/// 范畴定律（恒等律、结合律）——库自带的标准检查。
fn category_law_group(cat: &FiniteCategory) -> LawGroup {
    let identity_ok = cat.check_identity_laws();
    let associativity_ok = cat.check_associativity();
    let mut failures = Vec::new();
    if !identity_ok {
        failures.push("恒等律：id ∘ f = f 且 f ∘ id = f 不成立".to_string());
    }
    if !associativity_ok {
        failures.push("结合律：(f ∘ g) ∘ h = f ∘ (g ∘ h) 不成立".to_string());
    }
    let passed = usize::from(identity_ok) + usize::from(associativity_ok);
    LawGroup {
        label: "范畴定律".to_string(),
        total: 2,
        passed,
        failed: failures.len(),
        failures,
        reason: None,
    }
}

/// 结构公理——目录按关系种类发，只认四类规范关系。
fn structural_axiom_group(onto: &OntologyDef) -> LawGroup {
    let found = onto
        .edges
        .iter()
        .filter(|e| STRUCTURAL_KINDS.contains(&e.kind.as_str()))
        .count();
    let reason = if found == 0 {
        let kinds: Vec<&str> = onto.edges.iter().map(|e| e.kind.as_str()).collect();
        Some(format!(
            "结构公理只对 {} 四类规范关系发布，本体的关系种类（{}）不属此类——不是没配，是这些关系本来就不带层级",
            STRUCTURAL_KINDS.join("、"),
            kinds.join("、")
        ))
    } else {
        None
    };
    LawGroup {
        label: "结构公理".to_string(),
        total: found,
        passed: found,
        failed: 0,
        failures: Vec::new(),
        reason,
    }
}

/// 领域公理——本体 `axioms:` 里声明的业务规则，逐条校验。
fn domain_axiom_group(onto: &OntologyDef, cat: &FiniteCategory) -> LawGroup {
    let mut passed = 0;
    let mut failures = Vec::new();
    for axiom in &onto.axioms {
        match check_axiom(axiom, cat) {
            Ok(()) => passed += 1,
            Err(message) => failures.push(format!("{} — {message}", axiom.id)),
        }
    }
    let total = onto.axioms.len();
    let reason = if total == 0 {
        Some("本体没有写 axioms: 子句——这是规则空白，等你填".to_string())
    } else {
        None
    };
    LawGroup {
        label: "领域公理".to_string(),
        total,
        passed,
        failed: failures.len(),
        failures,
        reason,
    }
}

/// 单条领域公理的校验。目前支持 `cardinality` 的 `min: N`。
fn check_axiom(axiom: &AxiomDef, cat: &FiniteCategory) -> Result<(), String> {
    match axiom.axiom_type.as_str() {
        "cardinality" => {
            let min = parse_min(&axiom.constraint)?;
            let target = Obj::new(axiom.target.clone());
            if !cat.objects.contains(&target) {
                return Err(format!("target 概念 {} 不在本体里", axiom.target));
            }
            let count = cat
                .morphisms
                .iter()
                .filter(|m| !is_identity(m) && m.dom == target && kind_of(m) == axiom.relation)
                .count();
            if count >= min {
                Ok(())
            } else {
                Err(format!(
                    "{} 的 {} 出边 {} 条，少于 min {}",
                    axiom.target, axiom.relation, count, min
                ))
            }
        }
        other => Err(format!("未知的公理类型 {other}")),
    }
}

/// 只认 `min: N`。
fn parse_min(constraint: &str) -> Result<usize, String> {
    constraint
        .trim()
        .strip_prefix("min:")
        .and_then(|rest| rest.trim().parse().ok())
        .ok_or_else(|| format!("constraint 只支持 min: N，收到 {constraint:?}"))
}

fn morphism_info(m: &Morphism) -> MorphismInfo {
    MorphismInfo {
        kind: kind_of(m),
        from: m.dom.0.clone(),
        to: m.cod.0.clone(),
    }
}

/// 装配整份报告。
pub fn build_report(onto: &OntologyDef, cat: &FiniteCategory) -> Report {
    let objects: Vec<ObjectInfo> = onto
        .concepts
        .iter()
        .map(|c| ObjectInfo {
            name: c.name.clone(),
            label: c.label.clone(),
        })
        .collect();

    let declared: Vec<Morphism> = cat
        .morphisms
        .iter()
        .filter(|m| !is_identity(m))
        .cloned()
        .collect();
    let identities = cat.morphisms.len() - declared.len();
    let counts = Counts {
        objects: onto.concepts.len(),
        declared: declared.len(),
        identities,
        total_morphisms: cat.morphisms.len(),
    };
    let morphisms: Vec<MorphismInfo> = declared.iter().map(morphism_info).collect();

    // 复合与派生：外 f、内 g，f.dom == g.cod 才能接上；复合结果不在已声明关系里的记一条派生。
    let mut composable_pairs = 0;
    let mut derived: Vec<MorphismInfo> = Vec::new();
    for f in &declared {
        for g in &declared {
            if f.dom != g.cod {
                continue;
            }
            composable_pairs += 1;
            let from = g.dom.0.clone();
            let to = f.cod.0.clone();
            let kind = format!("{}∘{}", kind_of(f), kind_of(g));
            let already_declared = onto.edges.iter().any(|e| e.from == from && e.to == to);
            let already_derived = derived
                .iter()
                .any(|d| d.from == from && d.to == to && d.kind == kind);
            if !already_declared && !already_derived {
                derived.push(MorphismInfo { kind, from, to });
            }
        }
    }

    let derived_reason = if derived.is_empty() {
        Some(if composable_pairs == 0 {
            "没有任何两条关系首尾相接（前一条的终点不是后一条的起点），结构上接不上——补配置也没用，要补能接上的关系".to_string()
        } else {
            "可复合的关系对，其复合结果已在已声明的关系里".to_string()
        })
    } else {
        None
    };

    let groups = vec![
        category_law_group(cat),
        structural_axiom_group(onto),
        domain_axiom_group(onto, cat),
    ];

    let mut relations: Vec<RelationInfo> = onto
        .edges
        .iter()
        .map(|e| RelationInfo {
            from: e.from.clone(),
            kind: e.kind.clone(),
            to: e.to.clone(),
            derived: false,
        })
        .collect();
    for d in &derived {
        relations.push(RelationInfo {
            from: d.from.clone(),
            kind: d.kind.clone(),
            to: d.to.clone(),
            derived: true,
        });
    }

    let conclusion = vec![
        format!(
            "清单里的关系全部由本体声明产出，派生 {} 条，没有推断成分。",
            derived.len()
        ),
        "要得到派生关系，本体需要补能首尾相接的关系；本报告不代补。".to_string(),
        "报告只列关系，判断由拿报告的一侧做。".to_string(),
    ];

    let analyzed = AnalyzedInfo {
        groups,
        composable_pairs,
        derived,
        derived_reason,
    };

    Report {
        category: onto.name.clone(),
        from: None,
        to: None,
        source: onto.source.clone(),
        trace: vec![
            Step {
                name: "装载".to_string(),
                status: StepStatus::Done,
                note: None,
            },
            Step {
                name: "分析".to_string(),
                status: StepStatus::Done,
                note: None,
            },
        ],
        results: Results {
            loaded: Some(LoadedInfo {
                objects,
                morphisms,
                counts,
            }),
            analyzed: Some(analyzed),
            translation: None,
        },
        relations,
        conclusion,
        pending: None,
    }
}

// ───────────────────────── 渲染 ─────────────────────────
//
// Markdown 与 JSON 两个出口在 [`super::common`]，within 与 between 共用。

// ───────────────────────── CLI 入口 ─────────────────────────

/// 执行 `category within`：装载 → 分析 → 渲染。未知范畴或格式报错，由调用方转成非零退出。
pub fn run(category: &str, options: &Options) -> Result<(), String> {
    let onto = load_ontology(category)?;
    let cat = build_category(&onto);
    let report = build_report(&onto, &cat);

    let text = match options.format.as_str() {
        "md" => render_markdown(&report),
        "json" => format!("{}\n", render_json(&report)?),
        other => return Err(format!("未知输出格式 {other}，只支持 md 或 json")),
    };

    match &options.out {
        Some(path) => {
            std::fs::write(path, text).map_err(|e| format!("写入 {} 失败：{e}", path.display()))?;
        }
        None => print!("{text}"),
    }

    let failed: usize = report
        .results
        .analyzed
        .as_ref()
        .map_or(0, |analyzed| analyzed.groups.iter().map(|g| g.failed).sum());
    if options.strict && failed > 0 {
        return Err(format!("严格模式：有 {failed} 条公理失败"));
    }
    Ok(())
}

// ───────────────────────── 测试 ─────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    /// 三份本体都要能取到、解析过、端点校验过。
    #[test]
    fn 三份本体都能装载() {
        for id in [
            "qtcloud-meta-cli-category",
            "qtcloud-code-cli",
            "qtcloud-work-cli",
        ] {
            assert!(has_ontology(id), "{id} 不在本体表里");
            let onto = load_ontology(id).unwrap_or_else(|e| panic!("{id}：{e}"));
            assert!(!onto.concepts.is_empty());
            assert!(!onto.edges.is_empty());
        }
    }

    /// 未注册按错误返回，不静默降级。
    #[test]
    fn 未注册的范畴是错误() {
        assert!(!has_ontology("entity"));
        assert!(load_ontology("entity").is_err());
    }

    /// 回归：成环的本体建复合表不能失控——原实现在 code 的自环上吃到 3GB 中止。
    #[test]
    fn 成环的本体也能建范畴并过范畴定律() {
        for id in ["qtcloud-code-cli", "qtcloud-work-cli"] {
            let onto = load_ontology(id).unwrap();
            let cat = build_category(&onto);
            assert!(cat.check_identity_laws(), "{id} 的恒等律不成立");
            assert!(cat.check_associativity(), "{id} 的结合律不成立");
        }
    }

    /// 报告口径：过程两步都走到，计数与本体对得上，四组校验没有失败项。
    #[test]
    fn 报告里四组校验没有失败项() {
        let onto = load_ontology("qtcloud-meta-cli-category").unwrap();
        let cat = build_category(&onto);
        let report = build_report(&onto, &cat);

        assert_eq!(report.trace.len(), 2);
        assert!(
            report
                .trace
                .iter()
                .all(|step| step.status == StepStatus::Done)
        );

        let loaded = report.results.loaded.as_ref().unwrap();
        assert_eq!(loaded.counts.objects, onto.concepts.len());
        assert_eq!(loaded.counts.declared, onto.edges.len());

        let analyzed = report.results.analyzed.as_ref().unwrap();
        assert!(analyzed.derived.len() <= analyzed.composable_pairs);
        for group in &analyzed.groups {
            assert_eq!(
                group.failed,
                0,
                "{}：{}",
                group.label,
                group.failures.join("；")
            );
        }
    }
}
