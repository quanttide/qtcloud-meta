# 开发指南

面向维护 qtcloud-meta CLI 的开发者：工程结构、日常检查命令与文档同步约定。

## 工程结构

`src/cli` 是 qtcloud-meta 仓库内的独立 Rust 工程，不提交构建产物：

- `Cargo.toml`：包 `qtcloud-meta-cli`，版本 0.1.0，edition 2021，唯一二进制 `qtcloud-meta` 指向 `src/main.rs`；
- `src/main.rs`：程序入口，当前只打印 `qtcloud-meta`；
- `Cargo.lock`：锁定依赖版本，随 `Cargo.toml` 一并提交；
- `.gitignore`：忽略 `/target`，构建产物不入库。

## 日常检查

改动后本地双绿再提交，与 CI 保持一致：

```bash
cargo fmt --check
cargo clippy -- -D warnings
cargo build
```

## 文档同步

本目录四份文档从主文档分解而来，主文档 `docs/` 是两条流程的事实源。修改时：

1. 先改主文档或其用户指南、开发指南；
2. 检查本目录四份文档是否受影响，受影响则同步；
3. 保持分工不串：index 留全局，过程在用户指南，工程细节在开发指南，接口在 API 参考，同一事实只完整展开一次。

提交与推送按仓库约定在 qtcloud-meta 子模块内完成（分离头指针用 `git push origin HEAD:main`），回父仓库更新指针，详见主文档[开发指南](../../../../docs/dev-guide/index.md)的日常维护任务。
