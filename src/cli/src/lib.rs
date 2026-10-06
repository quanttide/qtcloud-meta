//! qtcloud-meta CLI 的库接口。
//!
//! 二进制 `qtcloud-meta` 与 `examples/category` 共用这一层：二进制只做参数解析，
//! 示例只做调用演示，范畴分析的实现都在 [`category`] 下。

pub mod category;
