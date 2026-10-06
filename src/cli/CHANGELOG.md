# Changelog

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

- 演示用的 `entity` / `process` 范畴与 `entity--process` 映射表
