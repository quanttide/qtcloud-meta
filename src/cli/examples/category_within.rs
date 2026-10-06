//! 范畴内分析的调用示例：实现全在 `src/category/within.rs`，这里只演示怎么调。
//!
//! 对应文档：`docs/user-guide/category/within.md`（报告要说清什么）、
//! `docs/dev-guide/category/within.md`（实现方案）。
//!
//! 跑法：
//!
//! ```text
//! cargo run --example category_within       # 打印 Markdown 报告
//! cargo run -- --category within media      # 命令行接口，可加 --format json / --out / --strict
//! ```

use qtcloud_meta_cli::category::within::{self, Options};

fn main() {
    let options = Options {
        format: "md".to_string(),
        out: None,
        strict: false,
    };

    if let Err(message) = within::run("media", &options) {
        eprintln!("错误：{message}");
        std::process::exit(1);
    }
}
