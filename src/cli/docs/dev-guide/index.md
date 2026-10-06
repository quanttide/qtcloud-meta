---
stage: clarifying
---

# 开发指南

面向维护 qtcloud-meta CLI 的开发者：工程结构、日常检查命令、本组文档的分工与同步约定。

## 工程结构

`src/cli` 是 qtcloud-meta 仓库内的独立 Rust 工程，不提交构建产物：

- `Cargo.toml`：包 `qtcloud-meta-cli`，版本 0.1.0，edition 2024，唯一二进制 `qtcloud-meta` 指向 `src/main.rs`；依赖 `clap`（参数解析）、`lau-category-theory` 0.1.0（范畴底座）、`serde` / `serde_json` / `serde_yml`（本体、映射表与报告的序列化）；
- `src/lib.rs`：库接口，只导出 `category` 一个模块；二进制与 `examples/` 共用这一层，参数解析与调用演示都不重写实现；
- `src/main.rs`：参数解析。两个子命令：`category within <范畴>` 与 `category between <源范畴> <目标范畴>`；
- `src/category/`：实现。`within.rs` 装载本体并跑数学校验，`between/` 走五步查表（`unify.rs` 融合型的语义、`common.rs` 步骤与报告骨架、`mod.rs` 入口），`common.rs` 放两个模块共用的报告结构与渲染；
- `examples/`：示例数据与调用演示。`category/*.yaml` 是本体，`between/*.yaml` 是映射表（六个 yaml 由 `include_str!` 在编译期编进二进制，装完不依赖源码树），`category_within.rs` 与 `category_between.rs` 是两份调用示例；
- `README.md`：包首页，`Cargo.toml` 的 `readme` 指向它；
- `Cargo.lock`：锁定依赖版本，随 `Cargo.toml` 一并提交；
- `.gitignore`：忽略 `/target`，构建产物不入库。

## 日常检查

改动后本地跑通与 CI 相同的检查再提交。CI 配置在仓库根的 `.github/workflows/ci.yml`，push 与 PR 时把工作目录切到 `src/cli` 执行同样四步：

```bash
cd src/cli
cargo build --locked
cargo test --locked
cargo clippy --locked -- -D warnings
cargo fmt --check
```

本仓测试目前为 0 条，四步里起作用的是编译、严格 lint 与格式检查：示例与二进制要能编过，clippy 的告警按 `-D warnings` 当错误处理。

## 本组文档的分工

- `category/index.md`：为什么是一个命令两个子命令，以及两者的输入输出；
- `category/within.md`：范畴内的实现——本体 schema、构造范畴、四组检查、报告；
- `category/between.md`：范畴间五步怎么落成代码，以及拆成 `unify` / `interface` 子命令的取舍；
- `category/common.md`：两个模块共用的报告结构与两个渲染出口；
- `category/subcategory.md`：融合型 between 的定性讨论，设计稿。

五篇当前都是 `clarifying` 档，按 [`../../CONTRIBUTING.md`](../../CONTRIBUTING.md) 的规则都不是事实源。

## 文档同步

本目录文档分四组从主文档分解而来：总览、用户指南、开发指南与 API 参考；用户指南按流程分本体、范畴两篇，范畴再分范畴内、范畴间，API 参考目前只有总览、没有命令篇；主文档 `docs/` 是两条流程的事实源。修改时：

1. 先改主文档或其用户指南、开发指南；
2. 检查本目录各组文档是否受影响，受影响则同步；
3. 保持分工不串：index 留全局与导航，过程在用户指南的本体、范畴两篇（范畴再分范畴内、范畴间），工程细节在开发指南，API 参考的总览留接口现状与职责边界、命令按流程分篇（当前无命令篇），同一事实只完整展开一次；
4. 每篇文档顶部标 `stage`（澄清 / 设计 / 实施 / 验收 / 发布），五档定义与事实源规则见 [`../../CONTRIBUTING.md`](../../CONTRIBUTING.md)：只有验收与发布两档能当事实源。

提交与推送按仓库约定在 qtcloud-meta 子模块内完成（分离头指针用 `git push origin HEAD:main`），回父仓库更新指针，详见主文档[开发指南](../../../../docs/dev-guide/index.md)的日常维护任务。
