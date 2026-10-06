---
stage: clarifying
---

# 一个命令，两个子命令

结论是 `category` 一个命令带 `within` / `between` 两个子命令，不是两个独立命令，也不是一个合并命令：

```bash
qtcloud-meta category within  <范畴>        [--format md|json] [--out <路径>] [--strict]
qtcloud-meta category between <源范畴> <目标范畴> [--format md|json] [--out <路径>]
```

## 为什么是一个命令

心智模型是同一个。用户想的是「对范畴做分析」，有时看内部，有时看跨范畴；就像 `git diff` 与 `git log` 属于同一个 git。

表和报告的约定共享。两者都读 `examples/` 下的表，都把结果交成同一份 `Report`，都遵循「CLI 出事实，判断由拿报告的一侧做」。这些约定集中在一个命令里维护，改一处两边同步。

代码本来就是兄弟。`within.rs` 与 `between/` 同在 `src/category/` 下，都是 `pub fn run()`，没有 `main`；`src/main.rs` 只负责解析子命令、调 `run()`、把 `Result` 交给退出处理，报告标题仍由各模块自己写，父层不加前缀。

可发现性。一个 `--help` 能同时列出两个子命令。

## 为什么不是一个合并命令

如果做成 `category analyze <源> [目标]`——给了目标就走 between、没给就走 within——省的参数不多，丢的是两件事的区分：

| | within | between |
|:--|:--|:--|
| 输入 | 一个范畴 | 源与目标两个范畴 |
| 步骤 | 装载 → 分析 → 返回 | 选定 → 映射 → 冲突 → 缺失 → 结论 |
| 数学 | 已上场，判自洽与接不上 | 还没上场，只查表 |
| 报告的 0 | 有的验过、有的空白、有的不可能 | 全是「还没做」 |

步骤数不同、数学成熟度不同、0 的含义不同。合并成一个出口，报告里就分不清「结构公理 0 条」和「映射规则缺失」是不是同一类事。

## 两者的输入输出

`within` 输入一个范畴标识，据此读 `examples/category/<范畴>.yaml`；输出四段：装载（对象与态射）、分析（四组校验与派生）、关系清单、给后续分析的结论。`--strict` 的作用是任一组出现失败就返回错误，不改报告内容。见 [within.md](within.md)。

`between` 输入源与目标两个标识，读两份本体加一张映射表 `examples/between/<源>--<目标>.yaml`；输出五步轨迹加两种收尾之一：翻译清单，或挂起的 change_request。缺表是停机位不是错误，返回值仍是成功。见 [between.md](between.md)。

两者的报告结构与 md、json 两个出口共用 [`common.md`](common.md) 里那一份 `Report`；`between` 的第一步还复用了 `within` 的装载函数——范畴未注册的判定与本体读取只有一处实现。

## 共享与不共享

共享的是报告骨架、两个渲染出口、三张表的读取位置（`examples/category/` 与 `examples/between/`）、以及「缺规则不代拟、停机位不报错」这条约束。

不共享的是语义：`within` 判结构（公理过不过、能不能复合出新关系），`between` 只查表做翻译（映射怎么读、冲突怎么判、结论是什么）。

## 待定

`between` 会不会拆成 `between unify` 与 `between interface` 两个子命令，取舍与迁移路径写在 [between.md](between.md)；对接型（函子校验）尚未实现。命令面到什么时候定稿见 [API 参考](../../api-references/index.md)。
