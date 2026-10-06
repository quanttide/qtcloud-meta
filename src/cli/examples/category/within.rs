//! 范畴分析的基本演示 —— 对应 `docs/user-guide/category.md` 的「装载与分析」三步。
//!
//! 1. 装载：本体与关系分别作为对象和态射装进范畴；
//! 2. 分析：按范畴的标准方法走——恒等、复合、范畴定律校验；
//! 3. 返回：打印一份关系报告，LLM 拿这份报告做进一步分析。
//!
//! 数据源是主文档 `docs/dev-guide/index.md` 的本体示例（Content / Account /
//! Material），只声明规格里有的类与关系，规格没有的层级不补。
//!
//! pr4xis 版本锁 0.29.1；许可证与引入结论见 `data/report/decision/pr4xis.md`。

use pr4xis::category::laws::category_law_axioms;
use pr4xis::category::{Category, Concept, FinitelyGenerated};
use pr4xis::ontology::Axiom;

pr4xis::ontology! {
    name: "Media",
    source: "qtcloud-meta docs/dev-guide/index.md 本体示例",
    concepts: [Content, Account, Material],
    labels: {
        Content: ("zh", "内容", ""),
        Account: ("zh", "账号", ""),
        Material: ("zh", "素材", ""),
    },
    edges: [
        (Content, Account, PublishedOn),
        (Content, Material, UsesMaterial),
    ],
}

/// 装载结果：对象与态射各有多少，标签从哪来。
struct Loaded {
    objects: Vec<MediaConcept>,
    morphisms: Vec<MediaRelation>,
    labels: Vec<(MediaConcept, String)>,
}

fn load() -> Loaded {
    let objects = MediaConcept::variants();
    let morphisms = MediaCategory::morphisms();
    let labels = MediaOntology::labels()
        .iter()
        .map(|(concept, _lang, label, _def)| (*concept, (*label).to_string()))
        .collect();
    Loaded {
        objects,
        morphisms,
        labels,
    }
}

/// 一组公理的校验结果：哪一组、几条、几条过、失败的原文。
struct LawGroup {
    label: &'static str,
    total: usize,
    passed: usize,
    failures: Vec<String>,
}

/// 分析结果：三组公理的校验、可复合的对数、复合出的新关系。
struct Analyzed {
    groups: Vec<LawGroup>,
    composable_pairs: usize,
    derived: Vec<MediaRelation>,
}

fn verify_group(label: &'static str, axioms: Vec<Box<dyn Axiom>>) -> LawGroup {
    let mut passed = 0;
    let mut failures = Vec::new();
    for axiom in &axioms {
        match axiom.verify() {
            Ok(_) => passed += 1,
            Err(counterexample) => failures.push(format!(
                "{} — {}",
                axiom.meta().name.as_str(),
                counterexample.meta().description.as_str()
            )),
        }
    }
    LawGroup {
        label,
        total: axioms.len(),
        passed,
        failures,
    }
}

fn analyze(morphisms: &[MediaRelation]) -> Analyzed {
    // 标准方法一：三组公理逐条校验——范畴定律（恒等律、结合律、态射闭包，
    // pr4xis 自带）、结构公理（目录按关系种类发）、领域公理（本体 axioms: 子句）。
    let groups = vec![
        verify_group("范畴定律", category_law_axioms::<MediaCategory>()),
        verify_group("结构公理", MediaOntology::generated_structural_axioms()),
        verify_group("领域公理", MediaOntology::generated_domain_axioms()),
    ];

    // 标准方法二：态射复合，复合结果不在已有态射里的就是派生关系
    let mut composable_pairs = 0;
    let mut derived = Vec::new();
    for f in morphisms {
        for g in morphisms {
            if f.to != g.from {
                continue;
            }
            composable_pairs += 1;
            if let Some(composed) = MediaCategory::compose(f, g)
                && !morphisms.contains(&composed)
                && !derived.contains(&composed)
            {
                derived.push(composed);
            }
        }
    }

    Analyzed {
        groups,
        composable_pairs,
        derived,
    }
}

fn main() {
    let loaded = load();
    let analyzed = analyze(&loaded.morphisms);

    let identities = loaded
        .morphisms
        .iter()
        .filter(|m| m.kind.name() == "Identity")
        .count();
    let declared = loaded.morphisms.len() - identities;

    // ── 报告：LLM 拿这份报告做进一步分析 ──
    println!("# 范畴分析报告");
    println!();
    println!("数据源：qtcloud-meta docs/dev-guide 本体示例");
    println!("方法：pr4xis 0.29.1 的恒等、复合与范畴定律校验");
    println!();
    println!("## 装载");
    println!(
        "- 对象 {} 个：{}",
        loaded.objects.len(),
        loaded
            .objects
            .iter()
            .map(|o| o.name())
            .collect::<Vec<_>>()
            .join("、")
    );
    for (concept, label) in &loaded.labels {
        println!("  - {} = {}", concept.name(), label);
    }
    println!(
        "- 态射 {} 条 = 恒等 {} 条 + 规格声明 {} 条",
        loaded.morphisms.len(),
        identities,
        declared
    );
    println!();
    println!("## 分析");
    for group in &analyzed.groups {
        println!(
            "- {}：共 {} 条，通过 {}，失败 {}",
            group.label,
            group.total,
            group.passed,
            group.failures.len()
        );
        for failure in &group.failures {
            println!("  - 失败：{failure}");
        }
        if group.total == 0 {
            match group.label {
                "结构公理" => println!(
                    "  - 原因：目录只对 Subsumption、Parthood、Causation、Opposition 四类规范关系发结构公理，规格里的 PublishedOn、UsesMaterial 不属此类"
                ),
                "领域公理" => println!("  - 原因：本体示例没有 axioms: 子句"),
                _ => {}
            }
        }
    }
    println!("- 可复合的态射对：{} 对", analyzed.composable_pairs);
    println!(
        "- 派生关系（复合得出且未声明）：{} 条",
        analyzed.derived.len()
    );
    if analyzed.derived.is_empty() {
        println!(
            "  - 原因：规格声明的 PublishedOn、UsesMaterial 不在可传递种类里，规格也没有成链的层级"
        );
    }
    println!();
    println!("## 关系清单");
    for m in &loaded.morphisms {
        if m.kind.name() == "Identity" {
            continue;
        }
        println!("{} -[{}]-> {}", m.from.name(), m.kind.name(), m.to.name());
    }
    for m in &analyzed.derived {
        println!(
            "{} -[{}]-> {}（派生）",
            m.from.name(),
            m.kind.name(),
            m.to.name()
        );
    }
    println!();
    println!("## 给后续分析的结论");
    println!(
        "1. 清单里的关系全部由规则产出，派生 {} 条，没有推断成分。",
        analyzed.derived.len()
    );
    println!("2. 要得到派生关系，规格需要补可传递的关系（如 is_a 层级）；本报告不代补。");
    println!("3. 报告只列关系，判断由拿报告的一侧做。");

    // 恒等态射是范畴的标准部件，这里取一条作为可运行的见证。
    let id_content = MediaCategory::identity(&MediaConcept::Content);
    println!();
    println!(
        "恒等见证：{} -[{}]-> {}",
        id_content.from.name(),
        id_content.kind.name(),
        id_content.to.name()
    );
}
