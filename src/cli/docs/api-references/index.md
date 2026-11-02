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

命令面已定并在发版：`paradigm within` / `paradigm between` / `property calibrate`，见上节命令树。设计依据一句话：谁在什么场合敲这条命令——改表的人改完当场验、跨域对接的人跑翻译、写 skill 的 agent 每次写完核字段。此前两版被否的设计（七个命令、单个 `change submit`）与理由存档在报告仓复盘 `data/report/retrospective/cli-naming.md`。

## 设计取向

下面几条是对命令行职责的判断，与具体命令无关，任何命令都要在它们之内：

1. CLI 出事实不做裁决：报告只列事实与轨迹，判断由拿报告的一侧做；规则写死，不调 LLM。
2. 缺规则不停机报错，停在指路：范式间缺映射表生成 change_request 点名该补的文件，属性校准把标准外字段收进待收录清单——补表复跑即接上。
3. 表是文件、快照保底：装载从当前目录向上找表，找不到回落内置快照，报告的装载步注明来源，出错能对账到具体一份。
4. 输出面向元智能体：任何输出的 `--json` 字段只加不改。
5. 命名先定轴再起名：一级名词域、二级共用动词表、全局参数按「每条命令都消费」准入，条文见复盘第四节。
