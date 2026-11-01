# qtcloud-meta CLI

量潮元数据命令行。它把本体装进范式里做结构分析，出两份报告：范式内看这套结构自不自洽、能不能复合出新关系；范式间看两个范式之间怎么走映射、缺什么规则。报告只出事实，判断由拿报告的一侧做。

## 安装

```bash
cargo install qtcloud-meta-cli
```

## 用法

```bash
qtcloud-meta paradigm within  <范式>            [--format md|json] [--out <路径>] [--strict]
qtcloud-meta paradigm between <源范式> <目标范式> [--format md|json] [--out <路径>]
```

表分两层：仓库内 `examples/paradigm/`、`examples/between/` 是正本——装载时从当前目录向上找文件，找到读文件；装完的二进制在别处运行、向上找不到表目录时，回落到内置快照（三份本体 `qtcloud-meta-cli-category`、`qtcloud-code-cli`、`qtcloud-work-cli`），装完即可用。报告的装载步会注明本次读的是文件还是快照。

```bash
qtcloud-meta paradigm within qtcloud-work-cli
qtcloud-meta paradigm between qtcloud-code-cli qtcloud-work-cli
```

范式间配了三条走向，首尾相接成圈：`code → work → meta → code`。反向没有映射表，会停在第 4 步生成 change_request——报告会指到该补的具体文件（`examples/between/<源>--<目标>.yaml`），补完复跑即接上：停机位是回路的入口，不是错误。

## 文档

包内 `docs/` 目录四篇：`index.md` 全局与导航，`user-guide/` 怎么用，`dev-guide/` 工程结构与实现，`api-references/` 接口现状。

## 依赖

范式底座是 [lau-category-theory](https://crates.io/crates/lau-category-theory) 0.1.0（MIT），本体与报告的序列化用 serde 系。

## 许可

CC BY 4.0，见仓库根 `LICENSE`。
