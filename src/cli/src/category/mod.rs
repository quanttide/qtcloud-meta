//! 范畴分析：范畴内（within）与范畴间（between）。
//!
//! within 装载本体、跑数学校验；between 只查表走五步，缺规则时停下等人填。
//! 两个模块共用 [`common`] 的报告结构与渲染出口。

pub mod between;
pub mod common;
pub mod within;
