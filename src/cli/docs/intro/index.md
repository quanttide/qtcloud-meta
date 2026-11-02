---
stage: clarifying
---

# 为什么值得用 qtcloud-meta

第二大脑的表越攒越多，问题也跟着长出来：你往本体表里加一个对象、把某个字段的写法改一下，三天后另一个域的报告对不上——没人说得清是哪次改动带坏的。字段约定靠口口相传，跨域的词汇翻译靠人记，新接手的人和新接手的 agent 第一周全在问「这个字段能不能这么写」。

qtcloud-meta 把这三件事从「靠人记」变成「跑一遍」。规则全部写死在代码里，不调 LLM：同一份表、同一个标准，跑一万次结果一样。

## 改表的人：改完当场知道改坏没有

你维护本体表或标准表。改动的代价原本是隐性的——表是 YAML，写错了编译器不拦、测试不报，要等下游的报告歪了才浮出来。

```bash
qtcloud-meta paradigm within qtcloud-work-cli          # 对象、关系、公理逐条过数学校验
qtcloud-meta property calibrate 你的表.yaml --strict   # 字段用法逐键核，有失败退出码 1
```

退出码是给脚本用的：配进检查脚本，改坏了当场红，不用等三天。这不是理论上的用法——拿校准器对自家范式表实跑过一次，当场列出 39 处偏差（概念名大小写、label 写成了对象、公理类型不在枚举里），每条带 `文件::路径`，逐条可对账。

## 对接两个域的人：翻译对不对，跑一遍就知道

code 域说 `CodeFinding`，work 域说 `WorkRecord`，两边的断言要互相翻译。原本这件事活在某个人的脑子里——他休假，翻译就停摆。

```bash
qtcloud-meta paradigm between qtcloud-code-cli qtcloud-work-cli
```

五步走完，实跑翻通 6 条断言：`ContractConfig → Artifact`、`CodeConfig → Criterion`……映射表是文件，补一处通一路；缺表时不报错退出，停在 change_request 点名该补哪个文件——补完复跑即接上。翻译从「某个人脑子里」搬进了仓库，谁来都一样。

## 新接手的人与 agent：字段怎么写，不用问人

约定如果只写在文档里，就会和现实脱节；写成机器可查的规则，才不会。

```bash
qtcloud-meta property calibrate examples/property/standard.yaml   # 标准自己先站得住
qtcloud-meta property calibrate 新文件.yaml                        # 哪里不合、哪些还没进标准，逐条列
```

标准表九条字段各带规则（类型、格式、正则、枚举），一条命令告诉你两件事：不合的在哪（改文件），标准没收的字段是哪些（补标准表）。对写 skill 的人尤其有用——把这条命令放进 skill，agent 每次真跑，不凭记忆猜约定。

## 它凭什么可信

- **不调 LLM**：同一输入永远同一输出，敢进检查脚本、敢写进 skill 当固定步骤。
- **表是文件**：每份报告的装载步注明本次读的是文件还是内置快照，出错了能对账到具体一份表。
- **尺子先自检**：标准表自己站不住（类型不是 OpenAPI 类型、正则编译不过）就拒绝校准——不拿歪尺子量东西。

## 三行起步

```bash
cd src/cli && cargo build
./target/debug/qtcloud-meta paradigm within qtcloud-work-cli
./target/debug/qtcloud-meta property calibrate examples/property/standard.yaml
```

用法细节见[用户指南](../user-guide/index.md)。
