---
stage: clarifying
---

# qtcloud-meta 命令行

qtcloud-meta 是**系统的元认知工具**：写资料的 AI 没有连续的记忆，写下的资料容易概念不一致；这套命令把「什么算一致」立成概念体系，拿它照系统写下的资料。本页只留全局与导航，文档组从[《三层极简架构方案》](../../../docs/index.md)逐层分解而来。

## 在平台中的位置

命令行照两面：

1. [范式照结构](user-guide/paradigm/index.md)——本体装进范式做数学校验，两个域之间查映射表翻译断言；
2. [属性照字段](user-guide/property.md)——字段用法对着标准属性表逐条核，不合的、标准没收的各出一份清单。

两面都只读表、只出报告，判断由拿报告的一侧做。边界：主文档里的本体写入流程（LLM 抽取 → 审批 → 写入 Turtle/OWL）是方案定义，录入命令尚未实现。

## 现状

`src/cli` 是已实现的 Rust 工程：包 `qtcloud-meta-cli`（crates.io 已发到 0.1.0-alpha.3），三条命令——`paradigm within`、`paradigm between`、`property calibrate`。命令面细节见[API 参考](api-references/index.md)。

## 文档导航

- [为什么用](intro/index.md)：说服页——定义的因果链、概念体系与三类用户的收益；
- [用户指南](user-guide/index.md)：构建与三条命令的实测用法，分本体、范式、属性几篇；
- [开发指南](dev-guide/index.md)：工程结构、日常检查与文档同步约定；
- [API 参考](api-references/index.md)：命令树、设计依据与设计取向。
