---
stage: clarifying
---

# qtcloud-meta CLI 文档组

qtcloud-meta CLI 的文档组，按雪花写作法从[《三层极简架构方案》](../../../docs/index.md)逐层分解：index 留全局与导航，细节展开到子页。

## 结构

- [index.md](index.md)：总览——定位一句、平台坐标、工程现状、导航分流。
- [intro/index.md](intro/index.md)：说服页——为什么值得用：因果链、概念体系、实跑证据、三类用户。
- [user-guide/](user-guide/index.md)：用法——构建、三条命令实测、开关与退出码；分本体、范式（内 / 间）、属性几篇。
- [dev-guide/](dev-guide/index.md)：工程——结构、日常检查、发布流程、文档分工与同步。
- [api-references/](api-references/index.md)：接口——命令树、设计依据与设计取向。

## 阅读顺序

- 第一次接触：先看 [index](index.md) 的坐标与现状；还没被说服，读 [intro](intro/index.md)。
- 要上手用：[user-guide](user-guide/index.md) → 对应分篇。
- 要改代码或改文档：[dev-guide](dev-guide/index.md)；查命令面：[api-references](api-references/index.md)。

## 编写约定

1. 每篇顶部标 `stage`，五档定义与事实源规则见 [`../CONTRIBUTING.md`](../CONTRIBUTING.md)。
2. 中文正文用直角引号「」；代码块标语言；一级标题全文唯一。
3. 同一事实只完整展开一次：index 不展开「为什么」，子页不重复总览。

## index 与 intro 的分工

总览两页同属 index 层，分的是两种读者、两个任务：**index 管地图，intro 管说服；定义在 index 是一句话，在 intro 是一篇。**

**[index.md](index.md) 是门牌加目录**，只留四样：

1. 定义句——系统的元认知工具，一句话压住；
2. 平台坐标——照两面（范式照结构、属性照字段）加一条边界（本体写入是方案定义、未实现）；
3. 工程现状——包、版本、命令面；
4. 文档导航——分流到 intro、用户指南、开发指南、API 参考。

不写「为什么」，不展开子页细节，不带实跑例子。

**[intro/index.md](intro/index.md) 是说服页**，展开四样：

1. 为什么非有它不可——AI 没有连续的记忆 → 概念必然不一致 → 光提醒没用，先立「什么算一致」；
2. 概念体系——范式、范畴、属性、公理、映射、标准，判法写死不调 LLM；
3. 实跑证据——范式照结构、属性照字段各一例；
4. 收益与起步——三类用户、三行起步。

不列文档目录，不写版本号、包名这类工程现状，不写平台坐标。

边界三条：

1. 重叠只允许一处：开头的定义句。index 一句话，intro 一篇。
2. 归属判断：讲「为什么值得用」进 intro；讲「在哪、现在做到哪、读哪篇」进 index；用法进 user-guide；工程进 dev-guide；接口进 api-references。
3. 两页都标 `stage`；定义口径是唯一重叠点，改一处必查另一处。
