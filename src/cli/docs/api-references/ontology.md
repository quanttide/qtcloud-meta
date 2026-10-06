# 本体的 API

本体写入这条流程对应 `change` 一个域，四个动作按一次变更的生命周期排列：提交、列清单、看详情、生效。全局选项、输出与退出码、命名规则见[API 参考](index.md)，流程各阶段的行为见主文档[用户指南](../../../../docs/user-guide/index.md)的「本体写入的过程」。

> 下列命令为设计稿，尚未实现。

这条流程的分界在变更落库：CLI 把链路执行到 `change_request` 为止，人类确认在审批页面完成，生效另走 `change apply`。

## change

```bash
qtcloud-meta change submit <输入路径> [--category <范畴>] [--ontology <路径>] [--dry-run]
qtcloud-meta change list [--status pending]
qtcloud-meta change show <变更 id>
qtcloud-meta change apply <变更 id> [--ontology <路径>] [--dry-run]
```

`submit` 读一篇非结构化文本（`-` 表示标准输入），依次做 LLM 抽取、按 `--category` 指定范畴的本体承诺对齐、SHACL 校验，最后写一条 `decision=pending` 的 `change_request`。输出变更 id、候选概念清单、对齐结论（复用、新增或冲突）、校验结果与风险等级，字段与主文档用户指南的抽取示例一致。本动作不改本体文件。

`list` 与 `show` 只读 `change_request` 表：前者按状态过滤出队列（id、动作、风险等级、创建时间），后者给出单条变更的候选定义、对齐结果、校验结果与出处片段。审批页面读的是同一张表，两边不各存一份队列。

`apply` 只接受 `decision=approved` 的请求，把候选定义写进 `--ontology` 指向的 Turtle/OWL 文件、本体版本加一，并把请求标为已生效；`rejected` 的请求原样留库，不写文件。

## 参数

`--ontology` 只挂 `submit` 与 `apply`：对齐要读本体文件，生效要写本体文件，`list` 与 `show` 只读库，不接受这个参数。`--category` 只挂 `submit`：指定按哪份本体承诺对齐，一次提交说一次。`--dry-run` 挂在两个写入动作上。

## 读写落点

| 动作 | 读 | 写 |
| :-- | :-- | :-- |
| `change submit` | 本体文件、`category` | `change_request` |
| `change list` / `change show` | `change_request` | 无 |
| `change apply` | `change_request` | 本体文件 |

四个动作都不碰范畴三表；本体写入与范畴表的唯一接触是 `submit` 按 `--category` 取本体承诺。
