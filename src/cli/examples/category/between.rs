//! 范畴间：选定 → 映射 → 冲突 → 缺失 → 结论 —— 对应
//! `docs/user-guide/category/between.md`。
//!
//! 三张表的字段取自主文档 `docs/dev-guide/index.md` 的范畴三表；示例数据取自主文档
//! `docs/user-guide/index.md` 的走查例子（「实体导向」→「流程导向」：内容 → 发布活动、
//! 素材 → 活动资源）。规则具体有哪些尚未定义，本模块只演示步骤顺序与缺规则时的停法，
//! 不代拟规则。

/// 范畴注册行（表 `category`），只取演示用到的字段。
pub struct Category {
    pub name: &'static str,
    pub commitment: &'static str,
}

/// 范畴间映射行（表 `category_mapping`），`rules` 是源概念到目标概念的对照。
pub struct Mapping {
    pub source: &'static str,
    pub target: &'static str,
    pub rules: &'static [(&'static str, &'static str)],
}

/// 冲突记录行（表 `conflict`）。
pub struct Conflict {
    pub source: &'static str,
    pub target: &'static str,
    pub conflict_type: &'static str,
    pub resolution: &'static str,
}

/// 规则缺失时生成的变更请求（表 `change_request`，`action = map`）。
pub struct ChangeRequest {
    pub id: String,
    pub action: &'static str,
}

/// 一次跨范畴走查的结果：走到了哪几步、翻出了什么、有没有挂起的变更请求。
pub struct Report {
    pub steps: Vec<String>,
    pub conclusion: Vec<(String, String)>,
    pub pending: Option<ChangeRequest>,
}

/// 第 4 步：规则缺失时生成 `change_request` 等人类定义，分析暂停在当前范畴。
fn missing_rule(from: &str, to: &str, mut steps: Vec<String>) -> Report {
    let pending = ChangeRequest {
        id: format!("cr-map-{from}-{to}"),
        action: "map",
    };
    steps.push(format!(
        "4 规则缺失：生成 change_request {}（action={}），分析暂停在当前范畴",
        pending.id, pending.action
    ));
    Report {
        steps,
        conclusion: Vec::new(),
        pending: Some(pending),
    }
}

/// 按主文档的五步走一遍：选定范畴 → 映射翻译 → 冲突检查 → 规则缺失 → 输出结论。
pub fn walk(
    from: &str,
    to: &str,
    assertions: &[&str],
    categories: &[Category],
    mappings: &[Mapping],
    conflicts: &[Conflict],
) -> Report {
    let mut steps = Vec::new();

    // 第 1 步：选定范畴，读本体承诺
    let Some(category) = categories.iter().find(|c| c.name == from) else {
        steps.push(format!("1 选定范畴：{from} 未注册，停"));
        return Report {
            steps,
            conclusion: Vec::new(),
            pending: None,
        };
    };
    steps.push(format!(
        "1 选定范畴：{}，本体承诺 {}",
        category.name, category.commitment
    ));

    // 第 2 步：查 category_mapping 取映射规则
    let Some(mapping) = mappings.iter().find(|m| m.source == from && m.target == to) else {
        steps.push(format!("2 映射翻译：{from} → {to} 没有映射规则"));
        return missing_rule(from, to, steps);
    };
    steps.push(format!("2 映射翻译：查到 {} 条规则", mapping.rules.len()));

    // 第 3 步：查 conflict，命中 true_conflict 按既往裁决处理，无记录则继续
    match conflicts
        .iter()
        .find(|c| c.source == from && c.target == to && c.conflict_type == "true_conflict")
    {
        Some(hit) => steps.push(format!(
            "3 冲突检查：命中 true_conflict，按既往裁决处理（{}）",
            hit.resolution
        )),
        None => steps.push("3 冲突检查：无 true_conflict 记录，按主文档继续".to_string()),
    }

    // 第 4 步：逐条翻译，缺一条规则就停下等人类定义
    let mut conclusion = Vec::new();
    for assertion in assertions {
        let Some((_, target)) = mapping.rules.iter().find(|(source, _)| source == assertion) else {
            steps.push(format!("2 映射翻译：断言「{assertion}」没有对应规则"));
            return missing_rule(from, to, steps);
        };
        conclusion.push(((*assertion).to_string(), (*target).to_string()));
    }

    // 第 5 步：输出结论
    steps.push(format!(
        "5 输出结论：{} 条断言翻到「{to}」",
        conclusion.len()
    ));
    Report {
        steps,
        conclusion,
        pending: None,
    }
}

fn print_report(report: &Report) {
    for step in &report.steps {
        println!("- {step}");
    }
    if !report.conclusion.is_empty() {
        let joined = report
            .conclusion
            .iter()
            .map(|(source, target)| format!("{source} → {target}"))
            .collect::<Vec<_>>()
            .join("；");
        println!("- 结论：{joined}");
    }
    if let Some(pending) = &report.pending {
        println!("- 挂起：{} 等人类定义规则", pending.id);
    }
}

/// 两段演示：一次走通，一次因为映射表为空停在第 4 步。
pub fn run() {
    let categories = vec![Category {
        name: "实体导向",
        commitment: "实体、属性、关系",
    }];
    let mappings = vec![Mapping {
        source: "实体导向",
        target: "流程导向",
        rules: &[("内容", "发布活动"), ("素材", "活动资源")],
    }];
    let conflicts: Vec<Conflict> = Vec::new();
    let assertions = ["内容", "素材"];

    println!("# 范畴间报告：实体导向 → 流程导向");
    print_report(&walk(
        "实体导向",
        "流程导向",
        &assertions,
        &categories,
        &mappings,
        &conflicts,
    ));

    println!();
    println!("# 范畴间报告：同一段路，映射表为空（规则未定义的真实状态）");
    print_report(&walk(
        "实体导向",
        "流程导向",
        &assertions,
        &categories,
        &[],
        &conflicts,
    ));
}
