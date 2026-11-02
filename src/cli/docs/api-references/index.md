---
stage: clarifying
---

# API 参考

本页给两样东西：已实现的接口，以及命令设计的现状。怎么用看[用户指南](../user-guide/index.md)，工程结构看[开发指南](../dev-guide/index.md)，流程定义见主文档[用户指南](../../../../docs/user-guide/index.md)。

## 已实现的接口

包名 `qtcloud-meta-cli`，当前版本 0.1.0-alpha，edition 2024，第三方依赖：`clap`（命令行）、`lau-category-theory`（范式底座）、`serde`／`serde_json`／`serde_yml`（序列化）、`regex`（属性校准的 pattern）。命令名 `qtcloud-meta`，入口 `src/main.rs`，当前命令树：

- `paradigm within <范式>`：装载本体、跑数学校验，出范式内报告；
- `paradigm between <源> <目标>`：查映射表走五步，缺规则时停在 change_request；
- `property calibrate <YAML文件...>`：字段用法对标准属性表逐条核，标准外字段进待收录清单。

## 命令设计

当前没有命令设计。此前两版设计——七个命令的版本与只留 `change submit` 的版本——都已删除，仓库里没有可以照着实现的接口。三版设计与各自被否的理由写在报告仓的复盘 `data/report/retrospective/cli-naming.md`。

重新开命令树之前先回答一个问题：谁在什么场合敲这条命令。答不上来就不开。

## 设计取向

下面几条是对命令行在整个平台里职责的判断，与具体命令无关，任何一版命令设计都要在它们之内：

1. CLI 执行链路但不做裁决：链路止于 `change_request` 落库，人类确认留在审批页面，两边共享同一张队列表。
2. 命令行不碰本体文件：生效由审批侧写入 Turtle/OWL 文件，命令行只提交候选，本体变更因此可重放、可回滚、有版本号。
3. 状态只有两处：事实集中在 SQLite 单文件与 Turtle/OWL 文件，命令行只负责 SQLite 这一侧，不引入第三份状态。
4. 输出面向元智能体：将来任何输出的 `--json` 字段只加不改。
5. 命名先定轴再起名：一级名词域、二级共用动词表、全局参数按「每条命令都消费」准入，条文见复盘第四节。
