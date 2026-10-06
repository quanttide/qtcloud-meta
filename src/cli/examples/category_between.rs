//! 范畴间分析的调用示例：实现全在 `src/category/between/`——融合型在 `unify.rs`，
//! 步骤框架与报告骨架在与将来的对接型共用的 `common.rs`。这里只演示怎么调。
//!
//! 走的是三个子系统的成对走向，三家互为源与目标、首尾相接成一个圈：
//!
//! - `qtcloud-code-cli` → `qtcloud-work-cli`
//! - `qtcloud-work-cli` → `qtcloud-meta-cli-category`
//! - `qtcloud-meta-cli-category` → `qtcloud-code-cli`
//!
//! 本体在 `examples/category/` 下，三张映射表在 `examples/between/` 下，文件名是
//! `<源>--<目标>.yaml`。这三个 CLI 之间经常互相协作，走向就按协作的循环排。
//!
//! 范畴间只查表、不代拟规则：表在就走通到第 5 步，表缺就停在第 4 步生成变更请求等人填
//! （停机位，不是错误）。反向走向（如 work → code）没有表，跑起来就停在第 4 步。
//!
//! 跑法：
//!
//! ```text
//! cargo run --example category_between
//! cargo run -- category between qtcloud-code-cli qtcloud-work-cli
//! ```

use qtcloud_meta_cli::category::between::{self, Options};

fn main() {
    let options = Options {
        format: "md".to_string(),
        out: None,
    };

    // 三个子系统的协作圈：编程云 → 工作云 → 元工具 → 编程云
    let walks = [
        ("qtcloud-code-cli", "qtcloud-work-cli"),
        ("qtcloud-work-cli", "qtcloud-meta-cli-category"),
        ("qtcloud-meta-cli-category", "qtcloud-code-cli"),
    ];

    for (from, to) in walks {
        if let Err(message) = between::run(from, to, &options) {
            eprintln!("错误：{message}");
            std::process::exit(1);
        }
    }
}
