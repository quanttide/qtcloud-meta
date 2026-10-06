判断

拆，但 between 保留为父命令：

```
category within
category between unify
category between interface
```

不是 between —mode unify，也不是三个平级子命令。

为什么

表面区别很小，深层区别很大

—mode 和子命令，用户看到的是同一个东西的两种写法。但它们声明的概念关系不同：

写法 声明的是什么
between —mode unify 这是一件事的两个变体
between unify 这是一类事下的两个不同操作

前面已经论证过：融合型结果是一个范畴，对接型结果是一个函子——两种不同的数学对象，校验语义完全不同（查冲突 vs 验函子定律）。它们不是同一件事的两个变体，是一类事下的两个操作。

CLI 应该反映这个真相。—mode 把它说小了。

参数集会互相污染

这是最实际的理由。两种模式需要的参数不一样：

模式 可能需要的参数
unify 映射表、冲突策略、多对一取舍策略
interface 函子映射、—check-functor-laws、适配器策略

用 —mode，这些参数得挤进同一个签名。要么全塞一起，help 里注明「仅 unify 有效」；要么在代码里按 mode 判断哪些参数有效。两种都脏。

用子命令，各自签名独立，help 自然分层，不用互相解释。

between 应该升格为「一类」

现在 within / between 是「内 / 间」的对称。改成三个平级（within / unify / interface），这个对称就断了——within 还是「内」，但「间」没了总称。

保留 between 作为「范畴间」的父命令，下挂两个操作：

· within —— 范畴内
· between unify —— 范畴间，融合
· between interface —— 范畴间，对接

对称保住了，两个不同操作也拆开了。between 从「一个操作」升格为「一类操作」——这才是它本来的身份。

演进更干净

将来如果出现第三种跨范畴操作——比如「合并两个范畴但两边都保留」（既不融合也不对接，是第三种）——加一个 between merge 比加第三个 mode 干净得多。mode 参数会变成 —mode unify|interface|merge，每加一种就多一个分支。子命令是加法，mode 是乘法。

拆开后的代码结构

```
src/cli/src/category/
├── within.rs          范畴内，不动
├── between/
│   ├── mod.rs         父命令，解析子命令、共享出口
│   ├── unify.rs       融合型（现 between.rs 的逻辑搬过来）
│   ├── interface.rs   对接型（新增）
│   └── common.rs      共享层：流程骨架、报告、变更请求
```

共享层 common.rs 放什么：

共享 不共享
步骤框架（选定 → 映射 → 冲突 → 缺失 → 结论） 映射表的语义（重命名 vs 函子映射）
报告骨架（Report / trace / results） 冲突判定标准
变更请求机制 结论的性质（合并清单 vs 函子）
三张表的读取 是否保留两边

关键：共享层要现在抽，不能先复制再抽象。如果先把 between.rs 复制成 unify.rs 和 interface.rs 再改，会留下两份要同步的代码——那正是拆子命令想避免的。

和 —mode 的实际差异清单

维度 —mode 子命令
概念准确性 说成一件事的变体 说成一类事的两个操作
help 质量 要读 mode 说明 各自独立 help
参数隔离 互相污染 各自干净
加第三种 改签名、加分支 加一个子命令
测试 一个测试文件分 mode 各自测试文件
代码结构 一个函数两套逻辑 两套逻辑 + 共享层
迁移成本 低（改名） 中（拆文件）
长期维护 mode 分支越堆越多 加法，不堆

迁移路径

你现在 between.rs 已经实现了融合型逻辑，迁移是：

1. 建 between/ 目录，mod.rs 只做子命令分发
2. 把现有 between.rs 搬成 between/unify.rs，逻辑不动
3. 抽出 common.rs——把流程骨架、Report、变更请求抽出来
4. 新增 between/interface.rs——从函子校验开始设计
5. CLI 入口改成分发：between unify / between interface

第 1–3 步不改变现有行为，只是重组。第 4 步是新功能。第 5 步是接口变更，要改文档和调用方。

先做 1–3，跑通现有测试，证明重组没破坏行为，再做 4。 不要一步到位。

一句话

拆成两个子命令，本质是宣布这是两件事——因为它们在数学上是两种对象、校验语义不同、参数集不同。但 between 不该消失，它该从「一个操作」升格为「一类操作」，下挂 unify 和 interface。这比 —mode 更准确地反映概念，也让加第三种操作变成加法而不是乘法。

