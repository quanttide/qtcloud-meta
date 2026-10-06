# 范畴的 API

本页是范畴分析流程的命令设计：选定范畴、按函子映射翻译、比对既往裁决，规则缺失时登记变更等人类补规则。全局选项、输出与退出码见[API 参考](index.md)，流程的走法见主文档[用户指南](../../../../docs/user-guide/index.md)的「范畴分析的过程」。

> 下列命令为设计稿，尚未实现。

这条流程以读为主：翻译、查裁决、出结论都在内存里完成，只有映射规则缺失时才落一条变更等人类补规则。

## category

```bash
qtcloud-meta category list
qtcloud-meta category show <范畴>
```

读 `category` 表，输出注册名、方法论、对应的本体文件路径、本体承诺与状态。`show` 多打印该范畴承诺的实体、属性与关系清单，供分析前确认翻译的落脚点。

## mapping

```bash
qtcloud-meta mapping list [--from <范畴>] [--to <范畴>]
```

读 `category_mapping` 表，按来源与目标范畴过滤，输出函子规则、映射类型与置信度。

## conflict

```bash
qtcloud-meta conflict list
```

读 `conflict` 表，输出已记录的冲突断言、冲突类型与人类裁决结果。

## analyze

```bash
qtcloud-meta analyze --from <范畴> --to <范畴> [--input <文件>]
```

输入是元智能体给的断言，JSON 从标准输入或 `--input` 读入。执行顺序与主文档用户指南一致：查 `mapping` 取规则并翻译，查 `conflict` 比对既往裁决，命中 `true_conflict` 按既往裁决处理，规则缺失则写一条待人类定义映射的 `change_request` 并停下。规则齐时输出目标范畴下的整合结论，全程只读。

## 读写落点

| 命令 | 读 | 写 |
| :-- | :-- | :-- |
| `category` / `mapping` / `conflict` | 对应的一张表 | 无 |
| `analyze` | `category_mapping`、`conflict` | 规则缺失时写 `change_request` |

范畴分析不写本体文件，也不动 `entity` 与 `relation` 两表；写入的只有规则缺失时那一 `change_request`。
