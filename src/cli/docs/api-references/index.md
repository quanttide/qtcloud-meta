# API 参考

本页三样东西：已实现的接口、命令的命名规则、按两条流程组织的命令总览。命令细节随流程分解两篇——本体写入见[本体的 API](ontology.md)，范畴分析见[范畴的 API](category.md)。怎么用看[用户指南](../user-guide/index.md)，工程结构看[开发指南](../dev-guide/index.md)，流程定义见主文档[用户指南](../../../../docs/user-guide/index.md)。

> 命名规则、命令与参数均为设计稿，尚未实现。骨架阶段唯一落地的是「已实现的接口」一节，命令的名字与参数随实现调整。

## 已实现的接口

包名 `qtcloud-meta-cli`，版本 0.1.0，edition 2024，当前无第三方依赖。命令名 `qtcloud-meta`，入口 `src/main.rs`，运行向标准输出打印一行 `qtcloud-meta` 后正常退出，无子命令。

## 命名规则

一级按名词域切，整棵命令树只有四个域：`change` 本体变更、`category` 范畴、`mapping` 范畴间映射、`conflict` 冲突。一级不放动作词，读者一句话就能复述：一级是对象，二级是对对象做的动作。

二级共用一张动词表：`submit` 提交、`list` 列清单、`show` 看详情、`apply` 生效写入、`translate` 按映射翻译。一个域至少两个动作，新动作先查表再造词。

命令名取自用户嘴里的叫法——变更、范畴、映射、冲突，与 SQLite 表名重合只算实现细节的对应，不作命名依据。

参数分两层：全仓全局只留每条命令都消费的，其余挂在用它的子命令上；一个概念只留一套参数名。

## 命令总览

| 命令 | 流程 | 做什么 |
| :-- | :-- | :-- |
| `change submit` | 本体写入 | 提交一份输入，走完抽取、对齐、校验，产出待审批变更 |
| `change list` / `change show` | 本体写入 | 只读查看待审批队列与单条变更的详情 |
| `change apply` | 本体写入 | 把已批准的变更写入本体文件，本体版本加一 |
| `category list` / `category show` | 范畴分析 | 列出范畴与各自的本体承诺 |
| `mapping list` / `mapping show` | 范畴分析 | 列出与查看范畴之间的映射规则 |
| `mapping translate` | 范畴分析 | 按映射把断言翻到目标范畴，输出整合结论 |
| `conflict list` / `conflict show` | 范畴分析 | 查既往冲突与人类裁决 |

## 参数

全仓全局只有三个，因为每条命令都消费它们：`--db <路径>` 定位 SQLite 单文件（缺省 `meta.db`，环境变量 `QTCLOUD_META_DB`），`--json` 决定结果怎么输出，`--version` 打印版本号、与 `Cargo.toml` 一致。

域与子命令各自的参数不进全局：`--ontology <路径>` 只挂 `change submit` 与 `change apply`（对齐要读本体文件，生效要写本体文件，`list` 与 `show` 只读库，不给这个参数），环境变量 `QTCLOUD_META_ONTOLOGY` 是它的缺省；`--category <范畴>` 只挂 `change submit`，一次提交说一次按哪份本体承诺对齐；`--dry-run` 只挂写入型的 `change submit`、`change apply` 与会落变更的 `mapping translate`，只打印要写什么、写去哪，不落盘；`--from` 与 `--to` 是 `mapping translate` 的翻译端点，不表示「当前范畴」。

LLM 端点沿用 Ollama 自己的 `OLLAMA_HOST`，不另设变量；本地没起 Ollama 时 `change submit` 直接失败退出。

## 输出与退出码

标准输出只放结果与 `--json` 的 JSON，提示、进度与错误一律走标准错误，管道里不会混进别的东西。

退出码 0 表示成功，1 表示失败（输入读不到、校验不通过、LLM 不可达、范畴或映射不存在）。「等待人类确认」是正常结果而非失败：`change submit` 与 `mapping translate` 产出待审批变更时仍退出 0，靠输出里的变更 id 与状态表达下一步。

## 设计取向

1. CLI 执行链路但不做裁决：链路止于 `change_request` 落库，人类确认留在审批页面，两边共享同一张队列表。
2. 生效独立成一步：只有 `change apply` 改本体文件，页面不碰文件，本体变更可重放、可回滚、有版本号。
3. 分析默认只读：`mapping translate` 只在规则缺失时登记一条变更，翻译出的结论是输出，不是新状态。
4. 状态只有两处：事实集中在 SQLite 单文件与 Turtle/OWL 文件，CLI 是唯一入口，不引入第三份状态。
5. 输出面向元智能体：`--json` 的字段是脚本契约，只加不改。
6. 命名先定轴再起名：一级名词域、二级共用动词表、全局参数按「每条命令都消费」准入。三条来自报告仓的复盘 `data/report/retrospective/cli-naming.md`，本页是它落地后的命令面。
