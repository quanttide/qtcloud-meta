三个东西分别是什么

LoadedInfo（within）

```rust
pub struct LoadedInfo {
    pub objects: Vec<ObjectInfo>,      // 对象清单
    pub morphisms: Vec<MorphismInfo>,  // 态射清单
    pub counts: Counts,                // 计数：对象/声明/恒等/总数
}
```

是什么：装载阶段的产物——本体读进来之后，变成了哪些对象、哪些态射、各多少条。

作用：报告的第一段，也是分析的输入。它回答的是「这个范畴里有什么」。

性质：名词性的——是一份清单，不是一段过程。

AnalyzedInfo（within）

```rust
pub struct AnalyzedInfo {
    pub groups: Vec<LawGroup>,          // 三组公理校验结果
    pub composable_pairs: usize,        // 可复合对
    pub derived: Vec<MorphismInfo>,     // 派生关系
    pub derived_reason: Option<String>, // 派生为 0 时的原因
}
```

是什么：分析阶段的产物——三组公理过没过、复合算了多少对、派生了几条。

作用：报告的第二段，也是结论的来源。它回答的是「这套结构合不合规矩、能不能推出新东西」。

性质：也是名词性的——是一组校验结果，不是一段过程。

StepInfo（between）

在 between.rs 里，它其实不是结构体，就是：

```rust
pub struct Report {
    pub steps: Vec<String>,             // ← 这里
    pub conclusion: Vec<(String, String)>,
    pub pending: Option<ChangeRequest>,
}
```

是什么：走查过程的文本记录——「1 选定范畴：…」「2 映射翻译：查到 6 条规则」这种行。

作用：报告的主体，也是流程状态的唯一记录。它回答的是「走到哪一步了」。

性质：动词性的——是一段流水账，不是一份清单。

关键发现：它们不是同一类东西

映射表把 LoadedInfo → StepInfo、AnalyzedInfo → StepInfo 说成「报告里的分段——范畴内分『装载 / 分析』，范畴间分『五步』」，只差粒度。

但看代码就发现，这不是粒度问题：

 within 的两个 between 的 StepInfo
记录的是什么 产物（有什么、过没过） 过程（做了什么、到哪了）
数据类型 结构化（Vec<ObjectInfo>、Vec<LawGroup>） 纯文本（Vec<String>）
词性 名词 动词
回答的问题 「是什么」 「怎么走的」

这是两个维度的东西，被硬压进了同一个概念。 多对一的有损，损失的正是「产物 vs 过程」这个区别——翻过去之后，StepInfo 分不清这条步骤是一条清单还是一段流水。

为什么这会挡住融合

融合的目标是「两个模块遵循同一套结构」。但现在的结构里：

· within 只有结果维度——装载产出什么、分析产出什么。没有过程记录（它不需要，因为它只有两步，写死在代码里）。
· between 只有过程维度——走到哪一步。没有结构化结果（它的结论是 Vec<(String, String)>，很薄）。

两个模块各占一个维度。 映射表试图把一个维度翻到另一个维度，所以必然有损。

融合的方向不是「把结果压成步骤」，也不是「把步骤展开成结果」，而是承认报告本来就有两个维度，让两个模块都同时具备。

重新设计

```rust
pub struct Report {
    pub category: String,

    // 维度一：过程——走到了哪
    pub trace: Vec<Step>,

    // 维度二：结果——产出了什么
    pub results: Results,

    // 公共出口
    pub relations: Vec<RelationInfo>,
    pub conclusion: Vec<String>,
}

pub struct Step {
    pub name: String,          // 装载 / 分析 / 选定 / 映射 / 冲突 / 缺失 / 结论
    pub status: StepStatus,    // Done / Skipped / Pending
    pub note: Option<String>,  // 这一步发生了什么
}

pub enum StepStatus { Done, Skipped, Pending }

pub struct Results {
    pub loaded: Option<LoadedInfo>,            // within 填，between 不填
    pub analyzed: Option<AnalyzedInfo>,        // within 填，between 不填
    pub translation: Option<TranslationInfo>,  // between 填，within 不填
}
```

两个模块各自填自己有的那部分：

 trace results
within 装载、分析两步（写死） loaded + analyzed
between 选定、映射、冲突、缺失、结论五步 translation

映射表要改：

原映射 新映射 理由
LoadedInfo → StepInfo 删除 不是步骤，是结果
AnalyzedInfo → StepInfo 删除 同上
（无） Step → Step 过程维度自身对应
（无） LoadedInfo → LoadedInfo 结果维度自身对应
（无） AnalyzedInfo → AnalyzedInfo 结果维度自身对应

多对一的有损消失了，因为原来那两个映射本来就不该存在——它们跨了维度。

这个设计解决了什么

1. 融合有了公共结构：Report 统一，trace 和 results 是两个正交维度，谁都能填。
2. 有损映射消失：LoadedInfo 和 AnalyzedInfo 不再需要翻到 StepInfo，它们各自在 results 里保留原名。
3. between 的 steps: Vec<String> 升级为结构化：Step 有了 status 和 note，LLM 能读出「哪步跳过了、哪步挂起了」，不只是文本。
4. within 补上了过程维度：虽然现在只有两步写死，但将来如果加了步骤（比如增量分析），trace 能承载。

一句话

LoadedInfo / AnalyzedInfo 是结果维度的产物，StepInfo 是过程维度的轨迹。现在的映射跨了维度，所以有损。融合的正确做法不是把它们压成一个，而是把报告拆成 trace 和 results 两个正交维度，两个模块各填各的。这样公共结构有了，有损映射也没了。

要我把 Results 和 TranslationInfo 的字段也补全，给出一版完整的融合后 Report 结构吗？