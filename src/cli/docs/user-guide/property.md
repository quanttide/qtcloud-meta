---
stage: clarifying
---

# 属性校准

属性是概念体系里照字段的那一层。校准回答一个问题：这份 YAML 里的字段用法，合不合标准属性。

标准在 `examples/property/standard.yaml`，按 OpenAPI 风格写：`type` 是数据类型，`format`／`pattern`／`enum` 是修饰。九条确认字段（id、name、label、title、category、type、path、status、description）各带机器可查的规则；`type` 本身就是九条之一——系统定义的类型，取值陈述型或程序型。

```bash
qtcloud-meta property calibrate <YAML文件...> [--format md|json] [--out <路径>] [--strict]
```

## 四步轨迹

装载：标准表文件优先、快照保底，来源写进报告。

标准自检：type 都是 OpenAPI 数据类型、pattern 编译得过、枚举非空、属性名不重复——标准自己先站得住，站不住就拒绝校准。

校准：逐键对着标准核（嵌套键也走到），按 type／format／pattern／enum 逐项过；标准外的字段不停机，进待收录清单。标准表自己是尺子不是测量对象，对它跑校准只出结构自检。

结论：失败逐条列出，改目标还是改标准由标准维护者定；待收录要收进标准，补标准表后复跑即接上。

## 边界

- 只核 YAML；TOML 契约（qtfounder 系）不在靶内。
- 命中即核、未知即录：标准没收的字段不算错，算待定。
- `--strict` 只对失败生效，待收录不转非零。
