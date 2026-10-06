# 开发指南

面向刚接手 qtcloud-meta 维护的新人：先看清仓库现状，再按文档分工找到要改的地方，最后按仓库约定提交。

## 仓库现状

qtcloud-meta（量潮元云）位于 `domains/quanttide-meta/apps/qtcloud-meta`，是 quanttide-meta 的子模块：独立提交、独立推送，父仓库只更新指针。

仓库目前只有方案文档，没有实现代码；此前的 `src/studio` 已迁出至归档仓 platform/studio。当前的维护对象是文档，以及后续按方案落地的实现。

目录结构：

- `README.md`：仓库简介；
- `docs/index.md`：三层极简架构方案总览，只保留全局结构与文档导航；
- `docs/user-guide/index.md`：用户指南，完整的使用过程与示例；
- `docs/dev-guide/index.md`：本文件，方案细节与维护任务。

文档用雪花写作法逐层分解：`index.md` 建立对平台的全局想象，过程展开到用户指南，结构与实现细节展开到本文件。新增内容先判断归属，不把细节写回 `index.md`。接手后的阅读顺序：`docs/index.md` → `docs/user-guide/index.md` → 本文件。

## 方案细节

### 核心表结构

L1 主数据三表：实体实例、关系与变更请求，变更请求是人类审批的核心。

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

L3 范畴三表：范畴注册、范畴间映射（函子）与冲突记录，与 L1 同库不同表。

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

### 本体示例

L2 用 Turtle/OWL 文件描述，最小本体示例（自媒体场景）：

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

### 抽取 Prompt

LLM 抽取阶段用本体约束输出，Prompt 模板：

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

### 技术选型

| 层 | 组件 | 选型 | 说明 |
|:--|:--|:--|:--|
| L1 主数据 | 存储 | SQLite | 单文件，零运维，支持 JSON 字段 |
| L2 本体 | 编辑 | Protégé（设计时） | 设计期编辑本体文件 |
| L2 本体 | 推理校验 | Apache Jena / pySHACL | 本地推理与校验 |
| L3 范畴 | 存储 | SQLite（与 L1 同库不同表） | 范畴注册、函子映射、冲突记录 |
| LLM 知识库 | 本地 LLM | Ollama + Qwen2.5 / Llama3 | 本地跑，无需联网 |
| LLM 知识库 | 向量检索 | ChromaDB 或 SQLite + sqlite-vec | 存非结构化原文的向量，做语义检索 |
| LLM 知识库 | 编排 | LangChain 或 LlamaIndex | 编排「检索→抽取→对齐→校验→写入本体」流程 |
| 人类确认 | Web UI | FastAPI + 简单 HTML | 审批页面 |
| 事件通知 | — | 本地 SQLite trigger + 轮询 | 本地通知机制 |

全部本地运行，无需 Docker、Kafka、Neo4j、DataHub，一台开发机即可。

### 设计演进

方案从五层收敛为三层：

| 之前的五层方案 | 现在的三层方案 |
|:--|:--|
| L1 数据接入 + L2 事实源 | 合并为 L1 主数据 |
| L3 本体语义 | 保留为 L2 本体 |
| L4 元认知 | 保留为 L3 范畴 |
| L5 应用消费 | 简化为人类确认 Web 页 |
| Kafka + Debezium + DataHub + Neo4j | 全部去掉，用 SQLite + Ollama + ChromaDB |

核心保留：范畴注册、函子映射、冲突标注、人类确认。

核心砍掉：CDC 事件流、元数据管理平台、图数据库、微服务编排、多级审批引擎。

## 日常维护任务

1. 动笔前读父仓库的 AGENTS.md 与 CONTRIBUTING.md，按《量潮科技文档格式章程》写作；
1. 改完自查三处：`index.md` 的全局描述、用户指南的过程、本文件的细节是否一致；
1. 在本子模块内提交：先 `git status` 与 `git diff` 核对全量变更，只提交本次相关路径，提交信息用 `docs:` 前缀加中文说明；
1. 推送子模块时若处于分离头指针，用 `git push origin HEAD:main`；
1. 回父仓库 `domains/quanttide-meta` 更新子模块指针并提交推送，需要时逐层向上传递到根仓库。
