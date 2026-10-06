# 范畴的 API

范畴分析这条流程对应三个域：`category` 认识范畴与各自的承诺，`mapping` 认识范畴之间的规则并按规则翻译，`conflict` 认识既往裁决。全局选项、输出与退出码、命名规则见[API 参考](index.md)，流程的走法见主文档[用户指南](../../../../docs/user-guide/index.md)的「范畴分析的过程」。

> 下列命令为设计稿，尚未实现。

这条流程以读为主：翻译、查裁决、出结论都在内存里完成，只有映射规则缺失时才落一条变更等人类补规则。

## category

```bash
qtcloud-meta category list
qtcloud-meta category show <范畴>
```

`list` 读 `category` 表，输出注册名、方法论、对应的本体文件路径与状态。`show` 多打印该范畴承诺的实体、属性与关系清单，供翻译前确认落脚点。

## mapping

```bash
qtcloud-meta mapping list [--from <范畴>] [--to <范畴>]
qtcloud-meta mapping show <源范畴> <目标范畴>
qtcloud-meta mapping translate --from <范畴> --to <范畴> [--input <文件>] [--dry-run]
```

`list` 与 `show` 读 `category_mapping` 表：前者按来源与目标过滤出规则清单（映射类型与置信度），后者给出某一对范畴之间的规则条目。

`translate` 是这条流程唯一的动作：输入是元智能体给的断言，JSON 从标准输入或 `--input` 读入；按 `--from` 到 `--to` 的规则翻译，比对 `conflict` 里的既往裁决，命中 `true_conflict` 按既往裁决处理，规则缺失则写一条待人类定义映射的 `change_request` 并停下。规则齐时输出目标范畴下的整合结论，全程只读。

## conflict

```bash
qtcloud-meta conflict list
qtcloud-meta conflict show <冲突 id>
```

`list` 读 `conflict` 表，输出已记录的冲突断言、冲突类型与是否已裁决。`show` 给出单条冲突的双方断言与人类裁决结果。

## 读写落点

| 动作 | 读 | 写 |
| :-- | :-- | :-- |
| `category list` / `category show` | `category` | 无 |
| `mapping list` / `mapping show` | `category_mapping` | 无 |
| `mapping translate` | `category_mapping`、`conflict` | 规则缺失时写 `change_request` |
| `conflict list` / `conflict show` | `conflict` | 无 |

范畴分析不写本体文件，也不动 `entity` 与 `relation` 两表；写入的只有规则缺失时那一条 `change_request`。
