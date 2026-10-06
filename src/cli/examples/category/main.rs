//! 范畴的两层演示 —— 对应 `docs/user-guide/category/` 的两篇文档。
//!
//! - 范畴内（`within`）：装载 → 分析 → 返回，见 `docs/user-guide/category/within.md`；
//! - 范畴间（`between`）：选定 → 映射 → 冲突 → 缺失 → 结论，见 `docs/user-guide/category/between.md`。
//!
//! 范畴内用 lau-category-theory 0.1.0（MIT）；范畴间的规则尚未定义，只演示步骤骨架。

mod between;
mod within;

fn main() {
    within::run();
    println!();
    between::run();
}
