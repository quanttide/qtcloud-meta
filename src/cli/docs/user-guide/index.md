---
stage: clarifying
---

# 用户指南

这页讲怎么用：装上、跑起来、看懂报告。

## 安装

```bash
cargo install qtcloud-meta-cli
```

装完就有 `qtcloud-meta` 命令。要从源码构建或改代码，见[开发指南](../dev-guide/index.md)。

## 三条命令

### 范式内：这份本体立得住吗

什么时候用：你改了本体表，想知道对象、关系、公理还对不对。

```bash
qtcloud-meta paradigm within qtcloud-work-cli
```

你会看到什么——报告先交代这份表从哪读的，再逐个列出装进来的对象，最后给校验结论：

```text
# 范式分析报告：QtcloudWorkCli

本体表来源：文件 .../examples/paradigm/qtcloud-work-cli.yaml

## 装载
- 对象 13 个：Workspace、Workflow、Step、Criterion、...
```

白话：装得进、立得住，或者哪里挂了，一眼看到底。

### 范式间：两边的说法翻得通吗

什么时候用：一个域的断言要用到另一个域——code 域的东西要落进 work 域的账本。

```bash
qtcloud-meta paradigm between qtcloud-code-cli qtcloud-work-cli
```

你会看到什么——五步走完，翻通的逐对列出：

```text
- 2 映射翻译：查到 6 条规则
- 5 输出结论：6 条断言翻到「QtcloudWorkCli」
- 结论：ContractConfig → Artifact；CodeConfig → Criterion；...
```

缺翻译规则不算错误：报告会点名该补哪个文件，补完再跑就接上。

### 属性校准：字段写对了吗

什么时候用：你写完或改完一张表，想核字段合不合标准。

```bash
qtcloud-meta property calibrate 你的表.yaml
```

你会看到什么——不合的逐条列出（哪份文件、哪个路径、错在哪），还没进标准的字段单独一份清单。对标准表自己跑则只做体检：标准自己站得住，才敢拿去量东西。

## 常用开关

- `--format json`：默认输出给人看的文本，加这个变成给程序读的 JSON。
- `--out 文件.md`：存到文件，不打在屏幕上。
- `--strict`：有任何不合格就返回非零退出码，方便配进检查脚本。范式内和属性校准有；范式间缺规则是「等人补」，不算失败，没这个开关。

## 报告怎么读

每份报告都是一段一段的轨迹：走到了哪步、这步发生了什么。先看开头「表从哪读的」——如果你刚改过表、报告却没变，多半是命令没读到你的文件：装好的命令在别处运行时读不到本地表，会退回内置的副本。确认文件位置再跑一次。

## 这页之外

- [本体](ontology.md)：本体从哪来、怎么录——注意录入命令还没做，这页是流程定义。
- [范式](paradigm/index.md)：范式内、范式间两篇细讲。
- [属性](property.md)：九条字段标准各是什么。
- [API 参考](../api-references/index.md)：命令面与设计取向。
- 主文档[用户指南](../../../../docs/user-guide/index.md)：平台的整体流程。
