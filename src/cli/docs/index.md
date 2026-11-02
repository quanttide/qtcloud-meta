---
stage: clarifying
---

# qtcloud-meta 命令行

qtcloud-meta CLI 是量潮元云的本地命令行入口，也是**系统的元认知工具**：写资料的 AI 没有连续的记忆，概念容易不一致，这套命令把「什么算一致」立成概念体系（范式、范畴、属性、公理、映射、标准），拿它照系统自己写下的资料。本文档组按雪花写作法从[《三层极简架构方案》](../../../docs/index.md)分解而来，本页只留全局与导航。

## 在平台中的位置

命令行照两面，外加一条边界：

1. 范式照结构：本体和关系作为对象和态射装进范式，按范式论的标准方法做校验，报告返回给拿报告的一侧（含 LLM）做进一步分析。分析遵循既定规则，不是 LLM 猜；用法见[范式](user-guide/paradigm/index.md)。
2. 属性照字段：字段用法对着标准属性表逐条核，不合的、标准未收的各列一份清单；用法见[属性](user-guide/property.md)。
3. 边界：主文档流程里的本体写入（LLM 抽取 → 对齐 → 审批 → 写入 Turtle/OWL）是方案定义，录入命令尚未实现——现有命令只读表、只出报告，不写本体。

## 现状

`src/cli` 是已实现的 Rust 工程：包 `qtcloud-meta-cli`（crates.io 已发到 0.1.0-alpha.3），二进制 `qtcloud-meta`，三条命令——`paradigm within`、`paradigm between`、`property calibrate`。命令面的现状见[API 参考](api-references/index.md)。

## 文档导航

- [为什么用](intro/index.md)：定义为系统的元认知工具——AI 无连续记忆，先把「什么算一致」立成概念体系（范式、范畴、属性、公理、映射、标准），命令拿概念照资料；
- [用户指南](user-guide/index.md)：构建运行与三条命令的实测用法，过程分解为本体、范式、属性三篇；
- [开发指南](dev-guide/index.md)：工程结构、日常检查与文档同步约定；
- [API 参考](api-references/index.md)：包与二进制的当前接口、命令设计的现状与职责边界。
