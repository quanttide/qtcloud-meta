---
stage: clarifying
---

# 范畴间：实现与拆分取舍

对应 `src/category/between/`：`unify.rs` 是融合型的语义，`common.rs` 是步骤框架与报告骨架，`mod.rs` 只做再导出（外部调用路径仍是 `between::run`）。入口 `between::run(源, 目标, &Options)`。

## 五步怎么落成代码

| 步 | 谁写 | 实现 |
|:--|:--|:--|
| 1 选定范畴 | `between/common.rs` 的 `drive` | 装载两端本体，取源端概念名作本体承诺；未注册则报告写「未注册，停」并返回错误 |
| 2 映射翻译 | `unify.rs` | 读映射表；无表、或某条 `from` 没有目标 → 转第 4 步 |
| 3 冲突检查 | `unify.rs` | 查 `conflicts`，只认 `true_conflict`，其它类型忽略、继续 |
| 4 规则缺失 | `between/common.rs` 的 `assemble_report` | 停机位：`pending` 写 change_request，返回成功，不往下走 |
| 5 输出结论 | `unify.rs` | 翻译清单，逐条 `from → to` |

分工是固定的：`common.rs` 管步骤框架、报告骨架、change_request 编号、三张表的读取；`unify.rs` 管映射怎么读、冲突怎么判、结论是什么。将来加对接型就是照这个分工多一个 `interface.rs`，共享层不再动。

## 三张表

本体表与映射表都只读不写，源文件分别是 `examples/category/<标识>.yaml` 与 `examples/between/<源>--<目标>.yaml`，两者都由 `include_str!` 在编译期编进二进制（理由见 [within.md](within.md) 的装载一节）。映射表的键是 `<源>--<目标>`（`mapping_key`），哪一对范畴由键决定，表里不写；本体那一侧复用 `within::load_ontology`，范畴未注册的判定与读取只有一处实现。

表里没有这个键视为「没有规则」不是错误（`load_table` 返回 `None`），解析失败才是错误：

```yaml
mappings:
  - { from: CodeConfig, to: Criterion }   # from 空 = 断言没有对应规则
conflicts:
  - { type: true_conflict, resolution: "…" }   # 只有这一种类型被读取
```

现有三张表：`qtcloud-code-cli → qtcloud-work-cli` 6 行、`qtcloud-work-cli → qtcloud-meta-cli-category` 3 行、`qtcloud-meta-cli-category → qtcloud-code-cli` 3 行，`conflicts` 全空；反向三对没有表，走反向会停在第 4 步。

## 报告

trace 是固定五步：走到的 Done，没走到的 Skipped，停机位 Pending。结果维度只填 `translation`；收尾是 `conclusion` 与 `pending` 二选一，不同时出现。change_request 的编号是 `cr-map-<源范畴名>-<目标范畴名>`，取本体里的 `name` 字段而不是文件名。md 版式会跳过 Skipped 的步，json 序列化同一份 `Report`。

```bash
cargo run -- category between qtcloud-code-cli qtcloud-work-cli
cargo run -- category between qtcloud-work-cli qtcloud-code-cli   # 反向无表，停在第 4 步
cargo run --example category_between                              # 连走三段协作圈
```

## 拆成 `unify` / `interface` 两个子命令

判断是拆，但 `between` 保留为父命令：`category within` / `category between unify` / `category between interface`。既不是 `between --mode unify`，也不是三个平级子命令。

不是同一个东西的两个变体，是一类事下的两个操作：融合型的结果是一个范畴，校验语义是查冲突；对接型的结果是一个函子，校验语义是验函子定律——两种数学对象，两种表。`--mode` 把这层关系说小了。

参数集会互相污染。融合型要映射表与冲突策略，对接型要函子映射与适配策略；塞进同一个签名就得互相注明「仅某某模式有效」，用子命令则各自签名独立，帮助信息自然分层。

`between` 升格为父命令之后，`within` 是「内」、`between` 是「间」的对称保住了，将来第三种跨范畴操作（比如合并后两边都保留）是加一个子命令，而不是把 `--mode` 改成三选一。

## 迁移状态

原设计的五步里前 1–3 步（建目录、`between.rs` 搬成 `unify.rs`、抽出 `common.rs`，纯重组不改行为）已完成；第 4 步新增 `interface.rs`、第 5 步 CLI 改成两个子命令都未做——`src/main.rs` 现在仍是一个 `between` 吃两个范畴。

## 已知留白

冲突类型只有 `true_conflict` 一种，其它类型怎么办规则未定义，代码是「忽略、继续」。映射表没有校验：`from` 不在源本体、`to` 不在目标本体都能通过。`between` 不跑 `within` 的任何检查，本体结构坏了它照旧走到第 5 步。对接型的函子校验没有实现，翻完之后也没有人验结构有没有保住——这几条都写在[用户指南](../../user-guide/category/between.md)的「现在能做什么、不能做什么」里。
