# 本体的 API

本体写入这条流程在命令行上只有一个动作：`change submit`。全局选项、输出与退出码、命名规则见[API 参考](index.md)，流程各阶段的行为见主文档[用户指南](../../../../docs/user-guide/index.md)的「本体写入的过程」。

> 下列命令为设计稿，尚未实现。

这条流程的分界在变更落库：命令行把链路执行到 `change_request` 为止，人类确认与生效在审批页面完成。`list`、`show`、`apply` 这类查看与生效动作不在命令行上——待审批队列与单条详情由审批页面读同一张表展示，批准后写入本体文件也在审批侧。

## change submit

```bash
qtcloud-meta change submit <输入路径> [--category <范畴>] [--ontology <路径>] [--dry-run]
```

读一篇非结构化文本（`-` 表示标准输入），依次做 LLM 抽取、按 `--category` 指定范畴的本体承诺与现有本体对齐、SHACL 校验，最后写一条 `decision=pending` 的 `change_request`。输出变更 id、候选概念清单、对齐结论（复用、新增或冲突）、校验结果与风险等级，字段与主文档用户指南的抽取示例一致。

## 参数

`--category <范畴>` 说按哪份本体承诺对齐，一次提交说一次，缺省读环境变量 `QTCLOUD_META_CATEGORY`。`--ontology <路径>` 指向要对齐的 Turtle/OWL 本体文件，缺省读环境变量 `QTCLOUD_META_ONTOLOGY`。`--dry-run` 只打印要写什么、写去哪，不落盘。

LLM 端点沿用 Ollama 自己的 `OLLAMA_HOST`，不另设变量；本地没起 Ollama 时本命令直接失败退出。

## 读写落点

`change submit` 读 `--ontology` 指向的本体文件与 `category` 表（取本体承诺），写 `change_request`。它不写本体文件，也不动 `entity`、`relation` 与范畴三表。
