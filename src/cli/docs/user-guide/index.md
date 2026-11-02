---
stage: clarifying
---

# 用户指南

qtcloud-meta 是量潮的元数据命令行：把本体装进范式跑结构校验，对着标准表核字段用法，出三份报告。规则全部写死在代码里——不调 LLM，同一输入永远同一输出。

## 构建

```bash
cd src/cli
cargo build                    # 产物在 target/debug/qtcloud-meta
cargo run -- paradigm within qtcloud-work-cli   # 或直接跑产物
```

下文用 `qtcloud-meta` 代指这个二进制。

## 三条命令

### 范式内：这份本体装得进吗

题目：workCLI 的本体表装不装得进 lau 范畴的结构。

```bash
qtcloud-meta paradigm within qtcloud-work-cli
```

实际返回（节选）：

```text
# 范式分析报告：QtcloudWorkCli

数据源：.../qtcloud-work/src/cli：README.md，src/{workspace/model.rs, ...} 的领域模型
方法：lau-category-theory 0.1.0 的范式构造、恒等、复合与公理校验
本体表来源：文件 .../examples/paradigm/qtcloud-work-cli.yaml

## 装载
- 对象 13 个：Workspace、Workflow、Step、Criterion、WorkOrder、...
```

白话：报告头先交代三件事——代码数据源是哪、用什么数学方法校验、本体表这次读的是文件还是内置快照；装载步把对象、关系、公理逐条摆出来过数学校验，结尾给结论。

### 范式间：两份本体对得上吗

题目：code 域的断言翻译成 work 域的词汇，翻得通吗。

```bash
qtcloud-meta paradigm between qtcloud-code-cli qtcloud-work-cli
```

实际返回（节选）：

```text
# 范式间报告：QtcloudCodeCli → QtcloudWorkCli
- 1 选定范式：QtcloudCodeCli，本体承诺 ContractConfig、CodeConfig、...
- 2 映射翻译：查到 6 条规则
- 3 冲突检查：无 true_conflict 记录，按主文档继续
- 5 输出结论：6 条断言翻到「QtcloudWorkCli」
- 结论：ContractConfig → Artifact；CodeConfig → Criterion；AlignResult → Outcome；...
```

白话：五步走——选定、映射、冲突、缺失、结论。缺映射表时不是报错退出，是停在 change_request 指路：报告会点名该补的文件（`examples/between/<源>--<目标>.yaml`），补完复跑即接上。

### 属性校准：字段用法对标准核

题目：这份 YAML 的字段用法，合不合标准属性。

```bash
qtcloud-meta property calibrate examples/property/standard.yaml   # 对标准表自己：只出结构自检
qtcloud-meta property calibrate <你的文件.yaml ...>               # 对文档：逐键核
```

实际返回（对标准表，节选）：

```text
- 装载：标准表来源：文件 .../examples/property/standard.yaml
- 标准自检：9 条属性：type 都是 OpenAPI 类型，pattern 编译得过，枚举非空
- 校准：0 个文件：命中 0 处，通过 0，失败 0，待收录 0 处
```

白话：标准表自己是尺子不是测量对象，对它跑只出结构自检；对别的文件逐键核，失败逐条列出（改目标还是改标准由标准维护者定），标准外的字段进待收录清单——补标准表后复跑即接上。

## 三个通用开关

- `--format md|json`：默认 md 给人读，json 给脚本读，同源。
- `--out <路径>`：写文件，不打终端。
- `--strict`：任一失败退出码 1。`within` 和 `calibrate` 有；`between` 没有——它缺规则走 change_request 指路，不算失败，加了会报参数错。

退出码：0 正常；1 目标不在或校准有失败（如 `范式「no-such-paradigm」未注册`）；2 用法错（子命令写错、开关不存在——本 CLI 没有 `--version`）。

## 报告怎么读

每份报告都带轨迹（装载 → 分析 → 结论）。先看「装载」步：它写明本次读的是文件还是内置快照——表改了没生效，多半是装好的二进制向上找不到表目录、落回了快照。

## 文档导航

- [本体](ontology.md)：本体及关系的数据源主要是规格；命令行只提供本体录入格式，不提供 LLM，抽取与整理在进入命令行之前完成。
- [范式](paradigm/index.md)：本体及关系录入系统之后，范式的性质分析按既定规则走，不用 LLM 猜，分范式内、范式间两篇。
- [属性](property.md)：校准字段用法对不对得上标准属性，九条确认字段各带机器可查的规则。

命令与接口见 [API 参考](../api-references/index.md)，流程的行为定义见主文档的[用户指南](../../../../docs/user-guide/index.md)，构建环境见主文档[开发指南](../../../../docs/dev-guide/index.md)。
