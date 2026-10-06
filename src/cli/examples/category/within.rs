//! 范畴内：装载 → 分析 → 返回 —— 对应 `docs/user-guide/category/within.md`。
//!
//! 与 CLI 子命令同源：直接调用库里的 within 实现，读 `ontology/media.yaml`。
//! 底座是 lau-category-theory 0.1.0（MIT）。

use qtcloud_meta_cli::category::within::{self, Options};

pub fn run() {
    let options = Options {
        format: "md".to_string(),
        out: None,
        strict: false,
    };
    if let Err(message) = within::run("media", &options) {
        eprintln!("错误：{message}");
    }
}
