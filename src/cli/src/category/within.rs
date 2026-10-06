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
use std::path::{Path, PathBuf};

use super::common::{Report, Results, Step, StepStatus, render_json, render_markdown};

/// 结构公理只对这四类规范关系种类发布，别的种类不发布。
const STRUCTURAL_KINDS: [&str; 4] = ["Subsumption", "Parthood", "Causation", "Opposition"];

// ───────────────────────── YAML 本体 schema ─────────────────────────

/// 本体定义，对应 `docs/dev-guide/category/within.md` 的 ontology.yaml。
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

/// 按范畴标识定位本体文件：`examples/category/<范畴>.yaml`。
///
/// 本体是示例数据，归 `examples/`；`src/` 下只放实现。
pub fn ontology_path(category: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("examples")
        .join("category")
        .join(format!("{category}.yaml"))
}

/// 读并解析本体文件。
pub fn load_ontology(category: &str) -> Result<OntologyDef, String> {
    let path = ontology_path(category);
    let text = std::fs::read_to_string(&path)
        .map_err(|e| format!("读不到范畴「{category}」的本体文件 {}：{e}", path.display()))?;
    let onto: OntologyDef = serde_yml::from_str(&text)
        .map_err(|e| format!("范畴「{category}」的本体文件解析失败：{e}"))?;
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

/// 概念 → 对象，边 → 态射，再为所有首尾相接的声明边填复合表。
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

    // 复合表：f ∘ g，其中 f 是新关系（外），g 是既有关系（内），f.dom == g.cod。
    let declared: Vec<Morphism> = cat
        .morphisms
        .iter()
        .filter(|m| !is_identity(m))
        .cloned()
        .collect();
    let mut pairs: Vec<(Morphism, Morphism, Morphism)> = Vec::new();
    for f in &declared {
        for g in &declared {
            if f.dom != g.cod {
                continue;
            }
            let composed = Morphism::new(
                format!("({}∘{})", f.name, g.name),
                g.dom.clone(),
                f.cod.clone(),
            );
            pairs.push((f.clone(), g.clone(), composed));
        }
    }
    for (f, g, composed) in &pairs {
        cat.set_composition(f, g, composed);
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
