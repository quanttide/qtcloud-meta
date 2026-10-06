---
stage: clarifying
---

# 共用的报告结构

对应 `src/category/common.rs`。范畴内与范畴间共用这一份报告数据与两个渲染出口，不各算一遍。

## 两个正交维度

过程维度是 `trace`：这一步走到了没有、这一步发生了什么。一条 `Step` 有三个字段——步骤名、状态、备注；状态三档：`Done` 走到了，`Skipped` 没走到，`Pending` 停机位（等人填规则）。

结果维度是 `results`：产出了什么。三个字段都可选，谁有填谁——`loaded` 与 `analyzed` 由范畴内填，`translation` 由范畴间填。

分成两个维度而不是压成一个，是设计结论：装载与分析是名词性的产物（清单、校验结果），步骤是动词性的轨迹（走到哪了）。原设计里映射表把前两者都翻成步骤，多对一必有损，丢的正是「产物 vs 过程」这个区别。

## Report 的字段

| 字段 | 说明 |
|:--|:--|
| `category` | 给人看的标题：范畴内是范畴名，范畴间是「源 → 目标」 |
| `from` / `to` | 范畴间专用的可机读端点，范畴内留空 |
| `source` | 数据源，范畴内填本体的 `source` |
| `trace` | 过程轨迹 |
| `results` | 三个可选结果 |
| `relations` | 关系清单（范畴内填，声明边加派生关系） |
| `conclusion` | 结论若干句 |
| `pending` | 挂起的 change_request（范畴间缺规则时填，与 `conclusion` 不同时出现） |

`from` / `to` 单列出来的理由：`category` 在两个模块里含义不同，一个给人看、一个给机器读，同一个键不该有两种意思。

## 谁填哪一段

| 模块 | `trace` | `results` |
|:--|:--|:--|
| within | 装载、分析（两步写死，都是 Done） | `loaded` + `analyzed` |
| between | 选定、映射、冲突、缺失、结论五步 | `translation` |

## 两个渲染出口

`render_markdown` 按 `results.loaded` 有没有值选版式：有则是范畴内四段（装载、分析、关系清单、给后续分析的结论），没有则是范畴间五步轨迹加收尾（`pending` 或 `conclusion`）。`render_json` 序列化同一份 `Report`，两个出口同源。

模块里不再各自渲染：`within::run` 与 `between/common.rs` 的 `emit` 各拿一份 `Report` 选格式，再写 stdout 或 `--out` 指定的文件，两处的写文件行为一致。

范畴间那一层另有一份只在 `between/` 内部共用的骨架（五步的装配、停机位、change_request 编号、三张表的读取、流程驱动），归 [`between.md`](between.md)，不在本页展开。
