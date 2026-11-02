//! 范式分析：范式内（within）与范式间（between），外加属性校准（property）。
//!
//! within 装载本体、跑数学校验；between 只查表走五步，缺规则时停下等人填；
//! property 拿字段用法对着标准属性表逐条核，标准外的字段进待收录清单。
//! 三个模块共用 [`common`] 的报告结构与渲染出口。

pub mod between;
pub mod common;
pub mod property;
pub mod within;
