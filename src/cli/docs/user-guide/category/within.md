---
stage: clarifying
---

# 范畴内：装载与分析

这是 Rust 演示做的事，也是「分析」这一步的落点。代码在 [`examples/category/within.rs`](../../../examples/category/within.rs)，两层一起跑用 `cargo run --example category`。

1. 装载：本体 → 对象，关系 → 态射。Rust 里是 `MediaConcept::variants()` 与 `MediaCategory::morphisms()`。
2. 分析：走范畴论的标准方法，不靠 LLM 猜。落成三组公理校验加一次态射复合——范畴定律（恒等律、结合律、态射闭包）由 pr4xis 自带，结构公理由目录按关系种类发，领域公理是本体里的 `axioms:` 子句；复合只在 `f.to == g.from` 时成立，复合出来而未声明的就是派生关系。
3. 返回：把这一系列关系作为报告返回。

> CLI 出报告，LLM 拿报告做进一步分析。这是分工线：CLI 只产出事实清单——关系、公理通过或失败、派生关系——判断留给拿报告的一侧。

报告里的每一行都要能追到一条规则或一个公理：规格没写的东西（比如可传递的关系链）在报告里就写「0 条，原因是……」，不补。
