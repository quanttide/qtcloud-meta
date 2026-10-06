//! 范畴内分析的调用示例：实现全在 `src/category/within.rs`，这里只演示怎么调。
//!
//! 演示用的本体是 `examples/category/category-within.yaml`——它描述的就是范畴内实现自己的结构
//! （`OntologyDef` / `Report` / `Step` / `Results` 等十二个类型作概念，`Has*` 作关系）。
//!
//! 报告结构（`Report` / `Step` / `Results` / `StepStatus`）在两个模块间共用，
//! 见 `src/category/common.rs`；Markdown 与 JSON 两个出口共用同一份报告数据。
//!
//! 对应文档：`docs/user-guide/category/within.md`（报告要说清什么）、
//! `docs/dev-guide/category/within.md`（实现方案）。
//!
//! 跑法：
//!
//! ```text
//! cargo run --example category_within                    # 打印 Markdown 报告
//! cargo run -- --category within category-within         # 命令行接口，可加 --format json / --out / --strict
//! ```

use qtcloud_meta_cli::category::within::{self, Options};

fn main() {
    let options = Options {
        format: "md".to_string(),
        out: None,
        strict: false,
    };

    if let Err(message) = within::run("category-within", &options) {
        eprintln!("错误：{message}");
        std::process::exit(1);
    }
}
