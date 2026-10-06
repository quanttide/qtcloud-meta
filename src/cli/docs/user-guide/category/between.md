---
stage: clarifying
---

# 范畴间：五步走

下面是给 docs/user-guide/category/between.md 写的一份用户文档。它面向拿报告的人（产品 / 业务 / 下游分析），不是给数学家的，所以刻意避开范畴论术语，只在必要处点明「数学还没上场」。

—

范畴间分析

这一页讲什么

范畴内分析回答「一个范畴自己立不立得住」。范畴间分析回答另一个问题：从一个范畴走到另一个范畴，怎么走、走到哪、走不通时怎么办。

比如 qtcloud-code-cli 里一次代码审计，要落进 qtcloud-work-cli 的账本里用。中间要翻译、要查有没有冲突、要定结论——这一页就是讲这个过程的。

对应命令：between。现在配好的是三个子系统之间的三条走向，首尾相接成一个圈：

· qtcloud-code-cli → qtcloud-work-cli
· qtcloud-work-cli → qtcloud-meta-cli-category
· qtcloud-meta-cli-category → qtcloud-code-cli

反向走向没有映射表，跑起来会停在第 4 步。

什么时候用

· 你手上有一套本体，想复用到另一套本体里
· 你要把一套关系模型里的断言，翻译到另一套关系模型
· 你想知道「这两套模型能不能对上、对不上是缺什么」

如果只是检查单套模型对不对，用范畴内分析（within），不是这一页。

五步走

范畴间分析按固定的五步走。顺序是死的，不跳步。

第 1 步：选定范畴

确定当前在哪个范畴，读出它的本体承诺——也就是这个范畴承认哪些对象和关系。

· 如果这个范畴没注册，直接停。报告会写「未注册，停」。
· 走到了，报告写出它的名称和承诺。

第 2 步：映射翻译

查映射表，看有没有「从这个范畴到那个范畴」的翻译规则。

· 有规则：报告写出查到了几条，然后逐条翻译断言。
· 没有规则：报告写「没有映射规则」，进入第 4 步（规则缺失）。
· 有规则但某条断言对不上：报告写出「断言『××』没有对应规则」，同样进入第 4 步。

第 3 步：冲突检查

查冲突表，看这条路上有没有既往裁决。

· 命中 true_conflict：按既往裁决处理，报告写出裁决内容。
· 没有命中：报告写「无 true_conflict 记录，按主文档继续」。

注意：现在只认 true_conflict 这一种冲突类型。其它类型怎么办，规则还没定义，代码里是「忽略、继续」。这不是错，是留白。

第 4 步：规则缺失

只要第 2 步或第 3 步缺规则，就走这一步。

· 生成一张变更请求（change_request），记下缺的是哪条映射。
· 分析暂停在当前范畴，不往下走。
· 报告写出挂起的变更请求编号，等人类定义规则。

这一步是停机位，不是错误。系统在这等规则，不是算不出来。

第 5 步：输出结论

规则齐了、冲突查完，给出目标范畴下的整合结论。

· 报告写出「几条断言翻到了目标范畴」。
· 逐条列出：源概念 → 目标概念。

报告长什么样

走通的情况（qtcloud-code-cli → qtcloud-work-cli）：

```
# 范畴间报告：QtcloudCodeCli → QtcloudWorkCli
- 1 选定范畴：QtcloudCodeCli，本体承诺 ContractConfig、CodeConfig、AuditConfig、AlignResult、AlignIssue、ApiSignature、TestRef、CodeFinding、CodeSeverity、CodeEnrichedFinding、LlmInfo、CodeEvidence、CodeEvidenceChain、CodeSymbolTable、CodeSymbol、CodeSymbolKind、CodeRefLocation
- 2 映射翻译：查到 6 条规则
- 3 冲突检查：无 true_conflict 记录，按主文档继续
- 5 输出结论：6 条断言翻到「QtcloudWorkCli」
- 结论：ContractConfig → Artifact；CodeConfig → Criterion；AlignResult → Outcome；CodeEvidence → WorkRecord；CodeSymbolTable → Catalog；CodeSymbol → Entry
```

走不通的情况（反向没有映射表）：

```
# 范畴间报告：QtcloudWorkCli → QtcloudCodeCli
- 1 选定范畴：QtcloudWorkCli，本体承诺 Workspace、Workflow、Step、Criterion、WorkOrder、WorkRecord、Order、Artifact、Asset、Material、Catalog、Entry、Outcome
- 2 映射翻译：QtcloudWorkCli → QtcloudCodeCli 没有映射规则
- 4 规则缺失：生成 change_request cr-map-QtcloudWorkCli-QtcloudCodeCli，分析暂停在当前范畴
- 挂起：cr-map-QtcloudWorkCli-QtcloudCodeCli 等人类定义规则
```

怎么读这份报告

看三件事：

1. 走到第几步 —— 到第 5 步说明走通了；停在第 2 或第 4 步说明缺规则。
2. 有没有挂起 —— 有 change_request，就说明需要人去定义规则，系统不代拟。
3. 结论翻出了什么 —— 源概念对应到目标概念，这是翻译结果。

别误读的两点：

· 报告里所有「缺」，都是待填，不是不可能。系统现在只查表，还没到判「翻译对不对」那一步。
· 报告不替你判断。它列流程和结果，判断由拿报告的一侧做——这点和范畴内一致。

现在能做什么、不能做什么

 现状
能做的 按五步走，查三张表，缺规则时生成变更请求并停下
不能做的 判断一次翻译合不合法
为什么 映射规则和冲突类型的规则还没定义，判卷的数学还没上场
缺规则时 生成 change_request，等人填，不是报错

和范畴内分析的关系

 范畴内（within） 范畴间（between）
范围 一个范畴自己 从一个范畴到另一个
做什么 装载、分析、返回 选定、映射、冲突、缺失、结论
数学 已上场，能判「自洽 / 接不上」 还没上场，只会查表
遇到问题 「结构上接不上」——硬边界 「缺规则，等人填」——软停顿

一句话对照：

范畴内是判卷老师已经到场，能说「合法 / 不可能」。
范畴间是判卷老师还没到，现在只有流程在走——查表、缺规则、停下等人填。

下一步

这份文档描述的是当前状态。范畴间分析将来要补的是：翻完之后再验一次结构有没有保住，从而能说「这次翻译合法 / 不合法」。这一步依赖两张表的规则定义，规则定下来之前不会实现。

在那之前，between 给你的所有结论都是基于表的翻译结果，不是经过结构校验的翻译结果。

