---
stage: clarifying
---

# 用户指南

本文讲 qtcloud-meta CLI 的日常使用：怎么构建、怎么跑，以及两条流程各自在系统里的位置。命令与接口见 [API 参考](../api-references/index.md)，流程的行为定义见主文档的[用户指南](../../../../docs/user-guide/index.md)。

## 构建与运行

CLI 是 Rust 工程，在 `src/cli` 下用 Cargo 构建：

```bash
cd src/cli
cargo build
cargo run
```

当前 `cargo run` 输出一行 `qtcloud-meta` 后退出。平台其余组件的环境准备见主文档[开发指南](../../../../docs/dev-guide/index.md)。

## 两条流程

- [本体](ontology.md)：本体及关系的数据源主要是规格；命令行只提供本体录入格式，不提供 LLM，抽取与整理在进入命令行之前完成。
- [范畴](category/index.md)：本体及关系录入系统之后，范畴的性质分析按既定规则走，不用 LLM 猜，分范畴内、范畴间两篇。

> 命令尚未实现，CLI 当前处于骨架阶段：此前两版命令设计（七个命令、单个 `change submit`）都已删除，现在没有任何命令设计。上文是流程定义，命令落地后在此补充具体用法。
