---
stage: clarifying
---

# 范畴内：实现

对应 `src/category/within.rs`，入口 `within::run(范畴, &Options)`。流程是：YAML 本体 → serde 解析 → `lau-category-theory` 构造范畴 → 四组检查 → 装配报告 → md / json 两个出口（共用同一份数据）。

## 本体 schema

本体文件在 `examples/category/<范畴>.yaml`，数据与实现分放：`examples/` 只放示例数据，`src/` 只放实现。字段如下：

```yaml
name: QtcloudMetaCliCategory        # 必填，进报告标题
source: "…的数据来源"               # 可选
version: "1.0"                      # 可选

concepts:                           # 概念 → 对象
  - { name: Report, label: { zh: 报告 } }

edges:                              # 边 → 态射
  - { from: Report, to: Step, kind: HasTrace }

axioms:                             # 可选，领域公理
  - id: ax-report-has-trace
    description: "报告必须有过程轨迹"
    type: cardinality               # 目前只支持这一种
    target: Report
    relation: HasTrace
    constraint: "min: 1"            # 只认 min: N
```

`name` 是唯一必填字段；`source`、`version`、`axioms` 缺省即空。Rust 侧的结构体与之一一对应（`OntologyDef` / `ConceptDef` / `EdgeDef` / `AxiomDef`），字段名与上表一致，`axioms.type` 通过 `serde(rename)` 对上 YAML 里的 `type`。

三份现成本体是 `qtcloud-meta-cli-category`（16 概念 / 13 边）、`qtcloud-code-cli`（17 / 13）、`qtcloud-work-cli`（13 / 10）。

## 装载

三份本体在编译期由 `include_str!` 读进二进制：源文件仍是 `examples/category/<标识>.yaml`，`has_ontology` 判注册、`load_ontology` 取文本解析。范畴不在表里就是错误，范畴内没有停机位。之所以编译期读，是因为 `CARGO_MANIFEST_DIR` 指向构建期的源码目录——从 crates.io 装下来的二进制没有那个目录，也没有那份文件。读进来之后 `validate_ontology` 只查一件事：每条边的两端都必须在 `concepts` 里，缺一端就报错，不代补。

## 构造范畴

概念 → 对象，边 → 态射；态射名字是 `kind#from->to`，把种类和端点一起编进去，避免同一种类的名字互相顶掉（同一个 `kind` 打两条不同端点的边是合法的）。

然后填复合表，`build_category` 只建到长度 3：

- 长度 2：声明边两两首尾相接，写 `compose(声明, 声明)`；
- 长度 3：长度 2 的路径再往前、往后各接一条声明边，写 `compose(长度2, 声明)` 与 `compose(声明, 长度2)`。

停在长度 3 的理由是库的 `check_associativity` 遍历的三元组全部取自 `cat.morphisms`（对象恒等 + 声明边），它查表只有这四种形态；长度 3 的合成结果只被拿去比名字，不会再当键查表。原实现建到全闭包（合成再合成），遇到自环与互指时组合数失控，实测 `qtcloud-code-cli` 那份吃到 3GB 才中止。

合成结果的名字由**路径本身**决定、不带括号：库按名字判等，带括号的名字两侧永远不同，结合律就永远过不去。

## 四组检查

| 组 | 查什么 | 数据来源 |
|:--|:--|:--|
| 范畴定律 | 恒等律、结合律各一条，共 2 条 | 库的 `check_identity_laws` / `check_associativity` |
| 结构公理 | 只对 Subsumption、Parthood、Causation、Opposition 四类关系发布 | 目录按 `edges[].kind` 发，不看配置 |
| 领域公理 | 本体 `axioms:` 里声明的规则，逐条校验 | 本体自己声明 |
| 复合与派生 | 可复合的态射对、复合得出且未声明的关系 | 复合表 |

两处 0 会带原因写进报告，不只写数字：结构公理为 0 时说明「本体的关系种类不属那四类，不是没配」；派生为 0 时区分「没有任何两条关系首尾相接」与「复合结果都已在声明里」。领域公理为 0 时说明「没写 `axioms:` 子句，这是规则空白」。

领域公理目前只支持 `cardinality` 的 `min: N`：`target` 必须是本体里的对象，计的是这个对象上 `relation` 种类的出边条数（恒等不算）。未知的公理类型按错误返回，不静默跳过。

派生关系的判定：遍历声明边的可复合对，复合结果的端点对上已声明的边就算已声明（只比 `from` / `to`，不比种类）。

## 报告

外壳在 [`common.md`](common.md)：`Report` 的过程维度填两步（装载、分析，都是 Done），结果维度填 `loaded` 与 `analyzed`；`relations` 是声明边加派生关系的清单，`conclusion` 固定三句。装载段给对象与标签、态射的恒等与声明拆分；分析段给四组的通过情况与两个原因字段。

md 与 json 同源：序列化同一份 `Report`，md 按 `results.loaded` 有没有值选版式，所以 inside 模块里没有第二份渲染逻辑。

## CLI 与示例

```bash
cargo run -- category within qtcloud-meta-cli-category [--format json] [--out <路径>] [--strict]
cargo run --example category_within          # 同一份实现的调用演示
```

`--strict` 不改报告内容，只在任一组 `failed > 0` 时让 `run` 返回错误。

## 已知边界

公理类型只有 `cardinality` 一种，条件、唯一性、互斥都还写不进本体。结构公理只认四类规范关系，本体的 `Has*` 关系永远走不到它。派生关系的「已声明」只比端点，端点对上有平行边或自环时，复合出来的同端点关系会被当成已声明吞掉。图性质——自环、互指、无边概念——没有任何一组在查，本体规模也没有上限。
