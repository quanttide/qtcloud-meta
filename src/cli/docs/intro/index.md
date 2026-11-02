---
stage: clarifying
---

# 为什么值得用 qtcloud-meta

qtcloud-meta 是**系统的元认知工具**：帮助 AI 建立概念上的一致性。

写资料的是 AI，而 AI 没有连续的记忆——每次对话都是新起的一段，昨天写了什么、上次怎么定义的，都不在场。可写下的资料要长期共存：同一个东西在两篇文档里叫了两个名字，同一个字段在两份表里两种写法，两个域对同一个概念各说各话。这不是哪篇写得不好，是一群没有共同记忆的作者必然写出的结果——概念会不一致。

人发现自己在胡说，靠的是想一想「我刚才说了什么」。系统里没有一个能想起来的整体，就把「想一想」做成了命令行：三条命令，是系统对自己的三次追问。

## 我的概念体系自己站得住吗

```bash
qtcloud-meta paradigm within qtcloud-work-cli
```

对象、关系、公理逐条过数学校验。装载步先注明这份表读的是文件还是内置快照——出错了能对账到具体一份表，不靠印象。

## 我在两边说的是同一个东西吗

```bash
qtcloud-meta paradigm between qtcloud-code-cli qtcloud-work-cli
```

code 域的断言翻成 work 域，实跑翻通 6 条：`ContractConfig → Artifact`、`CodeConfig → Criterion`……映射表是文件，补一处通一路；缺表时不停在报错，停在 change_request 点名该补哪个文件，补完复跑即接上。

## 我写下的字段合乎共同约定吗

```bash
qtcloud-meta property calibrate 你的表.yaml
```

九条标准字段逐键核：不合的在哪（带「文件::路径」，改文件），标准还没收的有哪些（补标准表）。这不是设想——拿校准器对自家范式表实跑，当场列出 39 处偏差。

## 为什么它能替 AI 记住

因为规则写死、表是文件、不调 LLM：同一输入永远同一输出。**记忆不连续，标准连续**——AI 每次写完跑一遍，概念不一致当场现形，而不是等三天后下游报告歪了才有人发现。这也是它敢进检查脚本、敢写进 skill 当固定步骤的原因：不用信任作者的记忆，只用信任可以复跑的规则。

## 落到谁身上

- **改表的人**：改动的代价从隐形变当场——`--strict` 有失败退出码 1，配进检查脚本，改坏了当场红。
- **对接两个域的人**：翻译从「某个人脑子里」搬进仓库，谁来都一样。
- **写 skill 的人**：把校准命令放进 skill，agent 每次真跑，不凭记忆猜约定。

## 三行起步

```bash
cd src/cli && cargo build
./target/debug/qtcloud-meta paradigm within qtcloud-work-cli
./target/debug/qtcloud-meta property calibrate examples/property/standard.yaml
```

用法细节见[用户指南](../user-guide/index.md)。
