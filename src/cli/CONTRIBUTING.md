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
