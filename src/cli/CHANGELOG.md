# Changelog

## [Unreleased]

### 新增

- `docs/intro/index.md`：说服页——定义为「系统的元认知工具」：AI 无连续记忆、资料概念不一致；先把「什么算一致」立成概念体系（范式、范畴、属性、公理、映射、标准，判法写死不调 LLM），命令只是拿概念照资料的入口；收益落到改表、跨域对接、写 skill 三类用户；挂进文档导航
- 文档组按「系统的元认知工具」口径整理：总览定位与现状、API 参考的命令设计与设计取向、用户指南导语、范式状态表、README 导语；修掉「无命令设计」「仅输出一行」「两份报告」等过时表述；范式内、范式间两篇口述稿按章程规整格式（直角引号、表格、列表、代码块语言）；总览页两轮重写——先修结构（两面编号名副其实、导航不复述子页），再清内部信息（去包名、版本号、雪花方法与进度口吻，改读者视角的三块）；说服页同款重写——去术语轰炸与维护者证据，改普通读者的场景开场与白话检查说明，起步改为一条安装命令
- `docs/README.md`：按标准 README 结构重写——介绍、结构、阅读顺序、编写约定、index 与 intro 分工（规则保留，归入正常章节）
- 用户指南重写为实测用法：三条命令各配真实返回与白话、通用开关与退出码、报告读法；清掉「命令尚未实现」「两条流程」等过时表述

### 变更

- 文档错误修复：两处流程图代码块补 `text` 语言标注（仓级用户指南、开发指南），CONTRIBUTING 一处正文弯引号改直角引号；全量扫描确认断链为零、H1 唯一、开围栏全带语言
- 标准表分组键 `group` 改 `category`，值改英文机器名（identity／classification／location／status／content）——`category` 本身也是九条标准属性之一，与 `type` 同款双义；标准自检新增分组守卫：分组必须是英文机器名

## [0.1.0-alpha.3] - 2026-11-02

### 新增

- `property calibrate <YAML文件...>`：属性校准——字段用法对着标准属性表逐条核；标准表 `examples/property/standard.yaml` 按 OpenAPI 风格写（type／format／pattern／enum，九条确认字段，`type` 本身也是标准属性之一）；装载同范式表文件优先、快照保底；标准先自检再校准；失败逐条出报告，标准外字段进待收录清单（补标准表后复跑即接上）；`--strict` 失败转非零

### 变更

- 报告结构 `Results` 增校准维 `calibrated`，Markdown 出口按三维分版式
- 依赖新增 `regex`（标准表 pattern 校验）
- README／文档同步：三条用法、用户指南增属性篇、API 参考的已实现接口节更新到现状

## [0.1.0-alpha.2] - 2026-11-01

### 变更

- 命令 `category` 改名 `paradigm`，用户可见文案与全部文档里的「范畴」改「范式」——随领域边界重划，元工程领域内「范畴」专指康德式分类，数学结构称「范式」；Rust 标识符与 JSON 字段沿用底座库 lau-category-theory 的 category 词汇，不另造第三套
- `src/category/`、`docs/*/category/`、`examples/category/` 目录随词汇改名

### 新增

- 表改文件优先装载：从当前目录向上找 `examples/paradigm/`、`examples/between/` 的 yaml，找不到回落内置快照；报告的装载步注明本次读的是文件还是快照
- 停机位闭环：缺规则时 change_request 指到该补的具体文件，补完复跑即接上；未注册范式同样指到该建的本体文件

## [0.1.0-alpha.1] - 2026-10-06

首个 alpha，`category within` 与 `category between` 两条子命令可用。

### 新增

- `category between` 的示例改走三个真实子系统：`qtcloud-code-cli`、`qtcloud-work-cli`、`qtcloud-meta-cli-category` 三条映射表首尾相接成圈，示例连走三段
- README（包首页）与发布元数据：`description`、`license`、`repository`、`homepage`、`readme`
- 7 条测试：三份本体装载、未注册报错、成环本体回归、报告四组无失败、between 走通与停机、映射表键

### 修复

- 复合表只建到长度 3。原来建到全闭包，遇到成环的本体（`CodeEvidence` 自环、`WorkOrder ↔ WorkRecord` 互指）组合数失控，`qtcloud-code-cli` 实测吃到 3GB 才中止
- 本体与映射表由 `include_str!` 编进二进制。`CARGO_MANIFEST_DIR` 指向构建期的源码目录，从 crates.io 装下来的二进制没有那个目录，每条命令都会读不到文件

### 变更

- `qtcloud-code-cli-category`、`qtcloud-work-cli-category` 改名为 `qtcloud-code-cli`、`qtcloud-work-cli`
- 开发指南六篇按最新实现重写
- CI 由 push 触发的 `ci.yml` 换成 tag 触发的 `release-cli`：质量门禁 → 三平台二进制 → GitHub Release → crates.io

### 移除

- 演示用的 `entity` / `process` 范式与 `entity--process` 映射表
