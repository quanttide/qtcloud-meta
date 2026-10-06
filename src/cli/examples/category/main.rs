//! 范畴的两层演示 —— 对应 `docs/user-guide/category/` 的两篇文档。
//!
//! - 范畴内（`within`）：装载 → 分析 → 返回，见 `docs/user-guide/category/within.md`；
//! - 范畴间（`between`）：选定 → 映射 → 冲突 → 缺失 → 结论，见 `docs/user-guide/category/between.md`。
//!
//! pr4xis 版本锁 0.29.1；许可证与引入结论见 `data/report/decision/pr4xis.md`。

mod between;
mod within;

fn main() {
    within::run();
    println!();
    between::run();
}
