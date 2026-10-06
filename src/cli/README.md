# qtcloud-meta CLI

量潮元数据命令行。它把本体装进范畴里做结构分析，出两份报告：范畴内看这套结构自不自洽、能不能复合出新关系；范畴间看两个范畴之间怎么走映射、缺什么规则。报告只出事实，判断由拿报告的一侧做。

## 安装

```bash
cargo install qtcloud-meta-cli
```

## 用法

```bash
qtcloud-meta category within  <范畴>            [--format md|json] [--out <路径>] [--strict]
qtcloud-meta category between <源范畴> <目标范畴> [--format md|json] [--out <路径>]
```

内置三份本体——`qtcloud-meta-cli-category`、`qtcloud-code-cli`、`qtcloud-work-cli`——数据随二进制打包，装完即可用，不依赖源码树。

```bash
qtcloud-meta category within qtcloud-work-cli
qtcloud-meta category between qtcloud-code-cli qtcloud-work-cli
```

范畴间配了三条走向，首尾相接成圈：`code → work → meta → code`。反向没有映射表，会停在第 4 步生成 change_request 等人定义规则——这是停机位，不是错误。

## 文档

包内 `docs/` 目录四篇：`index.md` 全局与导航，`user-guide/` 怎么用，`dev-guide/` 工程结构与实现，`api-references/` 接口现状。

## 依赖

范畴底座是 [lau-category-theory](https://crates.io/crates/lau-category-theory) 0.1.0（MIT），本体与报告的序列化用 serde 系。

## 许可

CC BY 4.0，见仓库根 `LICENSE`。
