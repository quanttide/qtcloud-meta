# 开发指南

面向维护 qtcloud-meta CLI 的开发者：工程结构、日常检查命令与文档同步约定。

## 工程结构

`src/cli` 是 qtcloud-meta 仓库内的独立 Rust 工程，不提交构建产物：

- `Cargo.toml`：包 `qtcloud-meta-cli`，版本 0.1.0，edition 2024，唯一二进制 `qtcloud-meta` 指向 `src/main.rs`；
- `src/main.rs`：程序入口，当前只打印 `qtcloud-meta`；
- `Cargo.lock`：锁定依赖版本，随 `Cargo.toml` 一并提交；
- `.gitignore`：忽略 `/target`，构建产物不入库。

## 日常检查

改动后本地跑通与 CI 相同的检查再提交。CI 配置在 `.github/workflows/ci.yml`，push 与 PR 时在 `src/cli` 下执行同样四步：

```bash
cargo build --locked
cargo test --locked
cargo clippy --locked -- -D warnings
cargo fmt --check
```

## 文档同步

本目录文档分四组从主文档分解而来：总览、用户指南、开发指南与 API 参考，API 参考再按两条流程分解为本体、范畴两篇；主文档 `docs/` 是两条流程的事实源。修改时：

1. 先改主文档或其用户指南、开发指南；
2. 检查本目录各组文档是否受影响，受影响则同步；
3. 保持分工不串：index 留全局，过程在用户指南，工程细节在开发指南，API 参考的总览留全局选项与设计取向、命令随流程分解到本体与范畴两篇，同一事实只完整展开一次。

提交与推送按仓库约定在 qtcloud-meta 子模块内完成（分离头指针用 `git push origin HEAD:main`），回父仓库更新指针，详见主文档[开发指南](../../../../docs/dev-guide/index.md)的日常维护任务。
