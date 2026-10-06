# 本体的 API

本页是本体写入流程的命令设计：从一篇非结构化文本到一条待审批的本体变更，再到批准生效后的本体文件写入。全局选项、输出与退出码见[API 参考](index.md)，流程各阶段的行为见主文档[用户指南](../../../../docs/user-guide/index.md)的「本体写入的过程」。

> 下列命令为设计稿，尚未实现。

这条流程的分界在变更落库：CLI 把链路执行到 `change_request` 为止，人类确认在审批页面完成，生效另走 `change apply`。

## ingest

```bash
qtcloud-meta ingest <输入路径> [--category <范畴>] [--dry-run]
```

读一篇非结构化文本（`-` 表示标准输入），依次做 LLM 抽取、与现有本体对齐、SHACL 校验，最后写一条 `decision=pending` 的 `change_request`。输出变更 id、候选概念清单、对齐结论（复用、新增或冲突）、校验结果与风险等级，字段与主文档用户指南的抽取示例一致。本命令不改本体文件。

## change

```bash
qtcloud-meta change list [--status pending]
qtcloud-meta change show <变更 id>
qtcloud-meta change apply <变更 id> [--dry-run]
```

`list` 与 `show` 只读 `change_request` 表，审批页面读的是同一张表，两边不各存一份队列。`apply` 只接受 `decision=approved` 的请求，把候选定义写进 Turtle/OWL 文件、本体版本加一，并把请求标为已生效；`rejected` 的请求原样留库，不写文件。

## 读写落点

| 命令 | 读 | 写 |
| :-- | :-- | :-- |
| `ingest` | 本体文件、`category` | `change_request` |
| `change list` / `change show` | `change_request` | 无 |
| `change apply` | `change_request` | 本体文件 |

`ingest` 与 `change` 不碰范畴三表；本体写入对范畴表的唯一接触是按 `--category` 取本体承诺。
