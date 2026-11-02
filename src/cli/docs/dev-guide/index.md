---
stage: clarifying
---

# 开发指南

面向维护 qtcloud-meta CLI 的开发者：工程结构、日常检查命令、本组文档的分工与同步约定。

## 工程结构

`src/cli` 是 qtcloud-meta 仓库内的独立 Rust 工程，不提交构建产物：

- `Cargo.toml`：包 `qtcloud-meta-cli`，版本 0.1.0-alpha.3，edition 2024，唯一二进制 `qtcloud-meta` 指向 `src/main.rs`；依赖 `clap`（参数解析）、`lau-category-theory` 0.1.0（范式底座）、`serde` / `serde_json` / `serde_yml`（本体、映射表、标准表与报告的序列化）、`regex`（属性校准的 pattern 校验）；
- `src/lib.rs`：库接口，只导出 `paradigm` 一个模块；二进制与 `examples/` 共用这一层，参数解析与调用演示都不重写实现；
- `src/main.rs`：参数解析。两个顶层命令：`paradigm`（子命令 `within <范式>`、`between <源范式> <目标范式>`）与 `property`（子命令 `calibrate <YAML文件...>`）；
- `src/paradigm/`：实现。`within.rs` 装载本体并跑数学校验，`between/` 走五步查表（`unify.rs` 融合型的语义、`common.rs` 步骤与报告骨架、`mod.rs` 入口），`property.rs` 属性校准（标准表装载、标准自检、逐键核对），`common.rs` 放三个模块共用的报告结构与渲染；
- `examples/`：示例数据与调用演示。`paradigm/*.yaml` 是本体，`between/*.yaml` 是映射表，`property/standard.yaml` 是属性标准表（三张表均文件优先：装载时从当前目录向上找，找不到回落到 `include_str!` 编进二进制的快照），`paradigm_within.rs` 与 `paradigm_between.rs` 是两份调用示例；
- `README.md`：包首页，`Cargo.toml` 的 `readme` 指向它；
- `CHANGELOG.md`：发布版本记录，条目头写 `## [版本]`，发布预检查会按它校验；
- `scripts/`：发布预检查脚本，`validate-version.sh` 对齐 tag 与 `Cargo.toml`，`validate-changelog.sh` 查版本条目；
- `Cargo.lock`：锁定依赖版本，随 `Cargo.toml` 一并提交；
- `.gitignore`：忽略 `/target`，构建产物不入库。

## 日常检查

改动后本地跑通发布门禁相同的检查再提交。门禁在仓库根的 `.github/workflows/release-cli.yml`，推 `cli/*` tag 时执行：

```bash
cd src/cli
cargo build --locked
cargo test --locked
cargo clippy --all-targets --locked -- -D warnings
cargo fmt --check
```

本仓测试 16 条：范式内 4 条（三份本体装载、未注册报错、成环本体回归——复合表那次 3GB、报告四组无失败），范式间 3 条（走通五步、停机位、映射表键），属性校准 9 条（标准表装载自检、id 的 uuid 形状、name 的小写连字符、path 的目录与文件、type 的陈述型/程序型枚举、对象装进字符串字段、嵌套待收录走查、uuid 形状判定、报告四步）。clippy 按 `-D warnings` 当错误处理。

## 发布

推 `cli/<版本>` 触发 `release-cli`，五个 job 依次跑：

1. `check`：`scripts/validate-version.sh` 对齐 tag 与 `Cargo.toml` 的 `version`，`validate-changelog.sh` 查 `CHANGELOG.md` 里有没有 `## [版本]` 条目；
2. `quality-gates`：fmt、test、clippy、`cargo publish --dry-run --locked`；
3. `build-binaries`：Linux x86_64、macOS arm64、Windows x86_64 三平台 release 构建；
4. `upload-release-assets`：三份二进制挂上 GitHub Release，`-alpha` / `-beta` / `-rc` 标预发布；
5. `publish-crate`：推 crates.io（crate 名 `qtcloud-meta-cli`），已存在则跳过；token 用 Org 级的 `CRATES_API_TOKEN` / `CARGO_REGISTRY_TOKEN`。

发布前要对齐三样：`Cargo.toml` 的 `version` 与 tag 一致、`CHANGELOG.md` 有对应条目、工作区干净。

## 本组文档的分工

- `paradigm/index.md`：为什么是一个命令两个子命令，以及两者的输入输出；
- `paradigm/within.md`：范式内的实现——本体 schema、构造范式、四组检查、报告；
- `paradigm/between.md`：范式间五步怎么落成代码，以及拆成 `unify` / `interface` 子命令的取舍；
- `paradigm/common.md`：三个模块共用的报告结构与两个渲染出口；
- `paradigm/subcategory.md`：融合型 between 的定性讨论，设计稿。

五篇当前都是 `clarifying` 档，按 [`../../CONTRIBUTING.md`](../../CONTRIBUTING.md) 的规则都不是事实源。

## 文档同步

本目录文档分四组：总览（含说服页）、用户指南、开发指南与 API 参考；用户指南分本体、范式、属性三篇（范式再分范式内、范式间），API 参考总览带命令树；主文档 `docs/` 是三层方案的事实源，命令的实现现状以 `src/cli` 代码为准。修改时：

1. 先改主文档或其用户指南、开发指南；
2. 检查本目录各组文档是否受影响，受影响则同步；
3. 保持分工不串：index 留全局与导航，说服页讲定位，过程在用户指南的本体、范式、属性三篇（范式再分范式内、范式间），工程细节在开发指南，API 参考的总览留接口现状与命令树，同一事实只完整展开一次；
4. 每篇文档顶部标 `stage`（澄清 / 设计 / 实施 / 验收 / 发布），五档定义与事实源规则见 [`../../CONTRIBUTING.md`](../../CONTRIBUTING.md)：只有验收与发布两档能当事实源。

提交与推送按仓库约定在 qtcloud-meta 子模块内完成（分离头指针用 `git push origin HEAD:main`），回父仓库更新指针，详见主文档[开发指南](../../../../docs/dev-guide/index.md)的日常维护任务。
