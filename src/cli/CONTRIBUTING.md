# CLI 文档贡献指南

本文件约定 `src/cli/` 下文档的元数据与阅读规则。核心要求：文档的 `stage` 决定它能不能当事实源——写文档先标 stage，读文档先看 stage。

## 元数据

每篇文档在文件顶部写 YAML front matter，字段 `stage`，标注这篇文档当前在哪一档：

```yaml
---
stage: clarifying
---
```

## 五档 stage

- `clarifying`（澄清）：问题还在澄清，文档是讨论稿，结论随时会变；
- `designing`（设计）：方案已定稿，尚未实现；
- `implementing`（实施）：正在实现，文档随代码一起改；
- `accepting`（验收）：实现完成并已通过验收；
- `releasing`（发布）：已随版本发布。

stage 只随实际进展推进，不由文档本身的改写决定：写了设计稿不等于进入 `designing`，代码跑起来不等于 `accepting`。

## 事实源规则

只有 `accepting`（验收）与 `releasing`（发布）两档的文档可以当事实源。`clarifying`、`designing`、`implementing` 三档一律是过程稿，AI 不得把它们当作既定事实：不据此下结论，不把其中的结论抄进别的文档当成已定事实，不按它写代码或改代码；要引用先向用户确认这一条是否已经拍板。

`src/cli/docs/` 当前全部是 `clarifying`，按本文件的规则都不是事实源；两条流程的事实源是主文档 `docs/`，见 [docs/dev-guide/index.md](docs/dev-guide/index.md) 的文档同步一节。

## 依赖与工具的坑（踩过一次，别再踩）

- **`lau-category-theory` 的 `FiniteCategory::set_composition`** 只往 `composition` HashMap 插 `(f.name,g.name)→h`，**不往 `morphisms` 里加态射**；`check_associativity` 遍历的三元组全部取自 `cat.morphisms`。所以别在调用方自己建复合闭包（`within` 曾因此组合爆炸）——用有界展开。
- **`category within` 的组合爆炸**（2026-10-06 实证）：原实现“建到全闭包”遇到含自环/平行边的本体（`qtcloud-code-cli` 的 `CodeEvidence` 自环、`qtcloud-work-cli` 的 `WorkOrder↔WorkRecord` 互指）即崩：3GB `memory allocation failed`、exit 134、**stdout 0 行**。输出全空即爆点发生在渲染前；改用有界两步（长度 2 由声明边首尾相接、长度 3 在两端各接一条）。
- **`pr4xis` 的 `ontology!` 宏产物不直接满足 `Ontology` trait**（缺 `axioms()` 等）：入口是 `Ontology::axioms()` 返回 `Vec<Box<dyn Axiom>>`，结构公理用 `structural_axioms_for::<Self::Cat>()`。这类 API 别凭记忆写，下 `.crate` 源码（`~/.cargo/registry/src/index.crates.io-*/pr4xis-<ver>/`）grep derive 源的 doc 与测试。
- **定位数据文件不能用 `env!("CARGO_MANIFEST_DIR")`**：从 crates.io 装出的二进制没有源码树，运行时报 No such file；改成编译期 `include_str!` 把 `examples/*.yaml` 编进注册表（`ONTOLOGIES`/`MAPPINGS` + `has_ontology` 判注册 + 未知范式报错）。验收方式是把构建期源码树挪走后重跑。
- **Rust 测试函数名可中文但不能含裸阿拉伯数字**（`fn 没有表的走向停在第 4 步()` 被解析成参数列表，报 `missing parameters for function definition`）→ 写「第四步」或用下划线；测试子模块跨模块 `use` 私有导入报 E0603 时，在被测模块内重导出或改 `pub` 路径。
- **改包元数据要全仓 grep 旧值**：edition 2021→2024 后 `dev-guide` 与 `api-references` 仍写「edition 2021」，靠 `grep 'edition 2021'` 才发现。
- **`tantivy` 0.26 / `crates.io` API 的差异**（查版本时踩过）：`doc!` 宏 `#[macro_export]` 在 crate 根（`tantivy::doc!`，不在 `schema` 下）、没有 `Index::create_or_open`（用 `create_in_dir` / `open_in_dir`）；crates.io API 必须带 User-Agent（否则 403），返回的 crate 详情在顶层而不是 PyPI 的 `{"crate": …}` 嵌套。
- **子模块在分离头指针下 push 会静默失败**：报 `Everything up-to-date` 但 exit=0、实际没推，须 `git push origin HEAD:main`；收指针前先比对子模块 HEAD 与 `origin/main`，有并行提交先同步，否则指针回退。
