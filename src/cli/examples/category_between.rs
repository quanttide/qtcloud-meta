//! 范畴间分析的调用示例：实现全在 `src/category/between/`——融合型在 `unify.rs`，
//! 步骤框架与报告骨架在与将来的对接型共用的 `common.rs`。这里只演示怎么调。
//!
//! 走的是一对演示范畴：`entity`（实体导向）→ `process`（流程导向），
//! 本体在 `examples/category/` 下，映射表在 `examples/between/entity--process.yaml`。
//!
//! 范畴间只查表、不代拟规则：表在就走通到第 5 步；表缺就停在第 4 步生成变更请求等人填
//! （停机位，不是错误）。命令行现阶段仍是「一个 between 吃两个范畴」，
//! 拆成 `between unify` / `between interface` 是下一步。
//!
//! 跑法：
//!
//! ```text
//! cargo run --example category_between
//! cargo run -- --category between entity process
//! ```

use qtcloud_meta_cli::category::between::{self, Options};

fn main() {
    let options = Options {
        format: "md".to_string(),
        out: None,
    };

    if let Err(message) = between::run("entity", "process", &options) {
        eprintln!("错误：{message}");
        std::process::exit(1);
    }
}
