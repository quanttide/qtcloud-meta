---
stage: clarifying
---

# 开发指南

给要改 qtcloud-meta CLI 的人：代码长什么样、改完怎么验、怎么发版、文档动哪几处。

## 代码结构

`src/cli` 是本仓的独立 Rust 工程，一个二进制 `qtcloud-meta`，不提交构建产物：

- `src/main.rs`——参数解析，两个顶层命令 `paradigm` 与 `property` 分发到实现；
- `src/lib.rs`——库入口，只导出 `paradigm` 一个模块，二进制与示例共用；
- `src/paradigm/`——全部实现：
  - `within.rs`：装载本体、跑数学校验；
  - `between/`：五步查表（`common.rs` 步骤框架、`unify.rs` 融合型语义、`mod.rs` 入口）；
  - `property.rs`：属性校准（标准表装载、标准自检、逐键核对）；
  - `common.rs`：三个模块共用的报告结构与渲染；
- `examples/`——三张表的正本（`paradigm/` 本体、`between/` 映射表、`property/` 标准表）与两份调用示例（`paradigm_within.rs`、`paradigm_between.rs`）。表装载文件优先、从当前目录向上找，找不到才用编译进二进制的快照；
- `scripts/`——发布预检查：`validate-version.sh` 对齐 tag 与 `Cargo.toml`，`validate-changelog.sh` 查 CHANGELOG 条目；
- `Cargo.toml` / `Cargo.lock` / `.gitignore`——依赖、锁定与忽略规则。

## 改完怎么验

```bash
cd src/cli
cargo build --locked && cargo test --locked
cargo clippy --all-targets --locked -- -D warnings
cargo fmt --check
```

四条与发布门禁逐字一致（门禁在 `.github/workflows/release-cli.yml`），本地双绿约等于 CI 绿。测试 16 条：范式内 4、范式间 3、属性校准 9，具体名单跑 `cargo test -- --list` 看。

## 怎么发布

推 tag `cli/<版本>` 触发 `release-cli`，五步依次：校验（tag 对齐版本、CHANGELOG 有条目）→ 质量门（上面四条加 publish dry-run）→ 三平台二进制 → 挂 GitHub Release → 发 crates.io。发布前对齐三样：`Cargo.toml` 的 `version` 与 tag 一致、`CHANGELOG.md` 有对应条目、工作区干净。

## 文档动哪几处

- 分工与归属（index 管地图、intro 管说服、用法进 user-guide、工程进本页、接口进 API 参考）：[`../README.md`](../README.md)；
- `stage` 五档与事实源规则：[`../../CONTRIBUTING.md`](../../CONTRIBUTING.md)；
- 主文档 `docs/` 是三层方案的事实源；命令实现以 `src/cli` 代码为准，文档跟代码同步改。

本组五篇（都是 `clarifying` 档，都还不是事实源）：

- `paradigm/index.md`——为什么 `paradigm` 一个命令带两个子命令；
- `paradigm/within.md`——范式内实现：本体 schema、构造、四组检查、报告；
- `paradigm/between.md`——范式间五步的落码、三张表与拆分取舍；
- `paradigm/common.md`——共用的报告结构与两个渲染出口；
- `paradigm/subcategory.md`——融合型 between 的定性，设计稿。

提交与推送按仓库约定在子仓内完成（分离头指针用 `git push origin HEAD:main`），回父仓库更新指针，详见主文档[开发指南](../../../../docs/dev-guide/index.md)。
