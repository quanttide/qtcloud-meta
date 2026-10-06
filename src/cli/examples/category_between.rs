//! 范畴间分析的调用示例：实现全在 `src/category/between.rs`，这里只演示怎么调。
//!
//! 走的是工具自己的两个范畴——`category-within`（描述范畴内实现的本体）到
//! `category-between`（描述范畴间实现的本体），这两份本体在 `examples/category/` 下。
//!
//! 注意：这条走向**没有映射表**。范畴间分析只查表、不代拟规则，所以它会停在第 4 步
//! 生成变更请求等人填——这不是错误，是停机位。
//!
//! 跑法：
//!
//! ```text
//! cargo run --example category_between
//! cargo run -- --category between category-within category-between
//! ```

use qtcloud_meta_cli::category::between::{self, Options};

fn main() {
    let options = Options {
        format: "md".to_string(),
        out: None,
    };

    if let Err(message) = between::run("category-within", "category-between", &options) {
        eprintln!("错误：{message}");
        std::process::exit(1);
    }
}
