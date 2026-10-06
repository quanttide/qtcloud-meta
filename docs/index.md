# 三层极简架构方案

> 当前重点：本体（L2）的写入流程与范畴（L3）的分析流程。主数据（L1）的写入流程暂缓，L1 仅保留结构定义。

## 一、整体结构

```
┌─────────────────────────────────────────────┐
│  L3 · 范畴层                                │
│  不同方法论的本体如何共存、映射、切换         │
├─────────────────────────────────────────────┤
│  L2 · 本体层                                │
│  定义“世界由什么构成”——实体、属性、关系       │
├─────────────────────────────────────────────┤
│  L1 · 主数据层                              │
│  存实际数据实例，可追溯、可审批、可版本化     │
└─────────────────────────────────────────────┘
         ▲
         │ 本体写入 / 分析读取
         │
┌─────────────────────────────────────────────┐
│  LLM 知识库（驱动引擎）                      │
│  非结构化数据 → 抽取候选 → 对齐现有本体       │
│  → 本体变更（待审批）→ 人类确认 → 写入本体    │
└─────────────────────────────────────────────┘
```

本体写入流向：非结构化输入 → LLM 抽取 → 对齐本体 → 本体变更（待审批）→ 人类确认 → 写入本体文件生效。

范畴分析流向：元智能体分析任务 → 选定范畴 → 跨范畴映射翻译 → 冲突裁决 → 输出整合结论。

人类确认是 LLM 知识库与三层之间的唯一关卡。LLM 的产出默认是 draft 状态，人类审批后才生效。

## 二、三层详细说明

### L1 · 主数据层

做什么：存实际的实体实例数据。每条记录有状态、版本、来源、审批人。

本地环境选型：SQLite（单文件，零运维，支持 JSON 字段）。

核心表结构（最小集）：

```sql
-- 实体实例表
CREATE TABLE entity (
    id TEXT PRIMARY KEY,
    category_id TEXT NOT NULL,        -- 属于哪个范畴
    entity_type TEXT NOT NULL,        -- 属于哪个本体类
    data JSON NOT NULL,               -- 实例数据（JSON）
    status TEXT DEFAULT 'draft',      -- draft / active / retired
    version INTEGER DEFAULT 1,
    source TEXT,                      -- 来源（LLM抽取 / 人工 / 系统）
    created_by TEXT,
    approved_by TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 关系表
CREATE TABLE relation (
    id TEXT PRIMARY KEY,
    from_entity TEXT REFERENCES entity(id),
    to_entity TEXT REFERENCES entity(id),
    relation_type TEXT NOT NULL,      -- 本体中定义的关系名
    data JSON,
    status TEXT DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 变更请求表（人类审批的核心）
CREATE TABLE change_request (
    id TEXT PRIMARY KEY,
    entity_id TEXT,
    action TEXT NOT NULL,             -- create / update / merge / retire
    proposed_data JSON,
    human_edit JSON,                  -- 人类审批时的修正
    risk_level TEXT,                  -- low / medium / high
    decision TEXT DEFAULT 'pending',  -- pending / approved / rejected
    decided_by TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### L2 · 本体层

做什么：定义“世界由什么构成”。用 OWL 或 JSON Schema 描述实体、属性、关系、约束。

本地环境选型：Turtle/OWL 文件 + Apache Jena（本地嵌入式推理），或更轻量的 JSON Schema。

最小本体示例（自媒体场景）：

```turtle
@prefix : <http://example.org/mdm#> .

:Content a owl:Class ;
    rdfs:label "内容" .

:Account a owl:Class ;
    rdfs:label "账号" .

:Material a owl:Class ;
    rdfs:label "素材" .

:publishedOn a owl:ObjectProperty ;
    rdfs:domain :Content ;
    rdfs:range :Account .

:usesMaterial a owl:ObjectProperty ;
    rdfs:domain :Content ;
    rdfs:range :Material .

:title a owl:DatatypeProperty ;
    rdfs:domain :Content ;
    rdfs:range xsd:string .

:status a owl:DatatypeProperty ;
    rdfs:domain :Content ;
    rdfs:range xsd:string .
```

约束：用 SHACL 定义校验规则，本体变更与数据写入时自动检查。

### L3 · 范畴层

做什么：管理不同方法论的本体如何共存。每个范畴是一个独立的本体，声明自己的本体承诺。

本地环境选型：SQLite 表 + JSON 配置文件。

核心表结构：

```sql
-- 范畴注册表
CREATE TABLE category (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,               -- 如“流程导向”“实体导向”
    methodology TEXT,                 -- process / entity / event / capability
    ontology_file TEXT,               -- 对应本体文件路径
    commitment TEXT,                  -- 本体承诺声明
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 范畴间映射表（函子）
CREATE TABLE category_mapping (
    id TEXT PRIMARY KEY,
    source_category TEXT REFERENCES category(id),
    target_category TEXT REFERENCES category(id),
    mapping_type TEXT,                -- equivalent / weak / perspective_diff
    mapping_rule TEXT,                -- 映射表达式
    confidence REAL,
    approved_by TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 冲突记录表
CREATE TABLE conflict (
    id TEXT PRIMARY KEY,
    source_category TEXT,
    target_category TEXT,
    assertion_a TEXT,
    assertion_b TEXT,
    conflict_type TEXT,               -- perspective_diff / true_conflict
    resolution TEXT,
    resolved_by TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

范畴分析流程（元智能体整合不同方法论结论时）：

1. **选定范畴**：确定当前分析所处的范畴及其本体承诺。
2. **映射翻译**：查 `category_mapping`，按函子规则把当前范畴的概念翻译到目标范畴。
3. **冲突检查**：比对翻译后的断言，查 `conflict` 看是否已有人类裁决。
4. **兜底升级**：映射不存在或无既往裁决时，生成一条 `change_request` 等人类确认。
5. **输出结论**：在目标范畴下给出整合后的分析结论。

## 三、本体的写入流程：LLM 知识库（驱动引擎）

这是把非结构化数据写入本体层（L2）的引擎。主数据（L1）的写入流程暂缓，本文不展开。

### 工作流程

```
非结构化输入（文档/对话/网页）
        │
        ▼
┌───────────────────┐
│  LLM 抽取          │  从文本中抽取候选概念
│  → 候选类          │
│  → 候选属性        │
│  → 候选关系        │
│  → 附原文出处      │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│  本体对齐          │  与现有本体比对：已有 → 复用
│                   │  缺失 → 候选新增；矛盾 → 冲突候选
└───────────────────┘
        │
        ▼
┌───────────────────┐
│  本体校验          │  SHACL + 一致性检查：domain/range 对不对、
│                   │  新增是否破坏现有定义
└───────────────────┘
        │
        ▼
┌───────────────────┐
│  本体变更          │  生成 change_request（draft），
│                   │  记录候选定义、对齐结果与出处
└───────────────────┘
        │
        ▼
┌───────────────────┐
│  人类确认          │  审批通过 → 写入 Turtle/OWL 本体文件，生效
│                   │  审批拒绝 → 丢弃或退回修改
│                   │  修正内容 → human_edit 记录
└───────────────────┘
```

### 本地技术选型

| 组件 | 选型 | 说明 |
|:--|:--|:--|
| 本地 LLM | Ollama + Qwen2.5 / Llama3 | 本地跑，无需联网 |
| 向量库 | ChromaDB 或 SQLite + sqlite-vec | 存非结构化原文的向量，做语义检索 |
| 抽取框架 | LangChain 或 LlamaIndex | 编排「检索→抽取→对齐→校验→写入本体」流程 |
| 本体校验 | pySHACL | Python 库，本地校验 |
| 推理 | Apache Jena 或 owlready2 | 本地 OWL 推理 |

### LLM 抽取的 Prompt 模板（核心）

```python
EXTRACT_PROMPT = """
你是一个本体抽取引擎。从文本中抽取候选概念，用于扩充或修订本体。

## 现有本体
{ontology_ttl}

## 当前范畴
{category_name}: {category_commitment}

## 输入文本
{raw_text}

## 输出要求
返回 JSON 数组，每个元素格式：
{{
  "candidate_kind": "class / property / relation",
  "label": "候选概念名",
  "definition": "一句话定义",
  "domain": "（property/relation 必填）所属类",
  "range": "（property/relation 必填）取值类型或目标类",
  "matched_existing": "现有本体中对应的概念名，无则 null",
  "confidence": 0.0-1.0,
  "source_span": "原文片段"
}}

只输出 JSON，不要解释。
"""
```

### 人类确认的最小实现

不需要复杂的审批引擎。一张 `change_request` 表 + 一个简单的 Web 页面即可：

- 页面列出所有 pending 的本体变更请求
- 每条显示：LLM 抽取的候选概念、对齐结果（复用/新增/冲突）、本体校验结果、风险等级
- 人类可以：批准 / 拒绝 / 修正后批准
- 修正内容写入 `human_edit` 字段
- 批准后把变更写入 Turtle/OWL 本体文件，本体版本 +1

## 四、两条重点流程示例

### 示例一 · 本体写入

场景：一篇新文档引入了现有本体（Content / Account / Material）中没有的概念。

输入文档片段：

> 矩阵内的账号按周排期统一供稿，每篇稿件先过选题会再进入制作。

**Step 1 · LLM 抽取**

```json
[
  {
    "candidate_kind": "class",
    "label": "排期",
    "definition": "账号供稿的时间安排",
    "matched_existing": null,
    "confidence": 0.87,
    "source_span": "矩阵内的账号按周排期统一供稿"
  },
  {
    "candidate_kind": "class",
    "label": "选题会",
    "definition": "稿件进入制作前的评审环节",
    "matched_existing": null,
    "confidence": 0.84,
    "source_span": "每篇稿件先过选题会再进入制作"
  }
]
```

**Step 2 · 本体对齐**

现有本体只有 Content、Account、Material 三个类。「排期」「选题会」均无对应概念 → 两条候选新增，与现有定义无矛盾。

**Step 3 · 本体校验**

pySHACL + 一致性检查：新增两个独立类，不改动现有类与属性，domain/range 引用的类都存在。通过。

**Step 4 · 本体变更**

`change_request` 插入一条 pending 记录，action = `create`，`proposed_data` 记录候选类的 label、definition 与 source_span。

**Step 5 · 人类确认**

审批人确认两个概念值得入本体，点击批准 → 候选类写入 Turtle 本体文件，本体生效；拒绝 → 丢弃或退回修改。

### 示例二 · 范畴分析

场景：元智能体要做流程分析，当前处于「实体导向」范畴。

**Step 1 · 选定范畴**

当前范畴「实体导向」，本体承诺是实体、属性、关系。

**Step 2 · 映射翻译**

查 `category_mapping`，发现「实体导向」→「流程导向」的函子规则：「内容」→「发布活动」，「素材」→「活动资源」。按规则把分析对象翻译到目标范畴。

**Step 3 · 冲突检查**

查 `conflict`，看两个范畴对同一对象的断言是否已有人类裁决。无记录 → 继续；有 `true_conflict` 记录 → 按既往裁决处理。

**Step 4 · 兜底升级**

如果函子规则不存在，生成一条 `change_request` 等人类定义映射，分析暂停在当前范畴。

**Step 5 · 输出结论**

在「流程导向」范畴下给出流程视角的分析结论，回传给元智能体。

## 五、最小技术栈清单

| 层 | 组件 | 选型 |
|:--|:--|:--|
| L1 主数据 | 存储 | SQLite |
| L2 本体 | 编辑 | Protégé（设计时） |
| L2 本体 | 推理校验 | Apache Jena / pySHACL |
| L3 范畴 | 存储 | SQLite（与 L1 同库不同表） |
| LLM 知识库 | 本地 LLM | Ollama + Qwen2.5 |
| LLM 知识库 | 向量检索 | ChromaDB |
| LLM 知识库 | 编排 | LangChain |
| 人类确认 | Web UI | FastAPI + 简单 HTML |
| — | 事件通知 | 本地 SQLite trigger + 轮询 |

全部本地运行，无需 Docker、Kafka、Neo4j、DataHub。一台开发机即可。

## 六、与五层方案的关系

| 之前的五层方案 | 现在的三层方案 |
|:--|:--|
| L1 数据接入 + L2 事实源 | 合并为 L1 主数据 |
| L3 本体语义 | 保留为 L2 本体 |
| L4 元认知 | 保留为 L3 范畴 |
| L5 应用消费 | 简化为人类确认 Web 页 |
| Kafka + Debezium + DataHub + Neo4j | 全部去掉，用 SQLite + Ollama + ChromaDB |

核心保留：范畴注册、函子映射、冲突标注、人类确认。

核心砍掉：CDC 事件流、元数据管理平台、图数据库、微服务编排、多级审批引擎。

这样三层各司其职：主数据存事实，本体定结构，范畴管共存，LLM 做抽取，人类做确认。一台机器，一个 SQLite 文件，跑通完整链路。
