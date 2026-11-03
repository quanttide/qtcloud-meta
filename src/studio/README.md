# studio

量潮元数据工作台（Flutter 桌面 + Web，规划中）。当前状态：**交互设计定稿，未开工**——设计文档在 [`docs/dev-guide/studio.md`](../../docs/dev-guide/studio.md)：

- 三栏骨架：NavigationRail → 清单面板 → 详情区，设置沉底；
- 导航分区摆定义过的名词：**范式**（领域内或跨领域的结构）、**范畴**（标准范畴九宫格）、**属性**（属性标准），动作住工具带；
- 归属原则与详情工具带三规矩（安静、主行动唯一、靠右）；
- **范畴维护页**：编辑机读表、保存、跑校准；增删改名只列「待回正本」，gallery 正本不代改。

设计风格沿用 qtcloud-media-studio。范畴的读写分工：展示在 [lite](../lite/)（微信小程序，只读），维护在本工作台。

版本与发布按子包惯例：tag `studio/vX.Y.Z`，版本见 [CHANGELOG.md](CHANGELOG.md)。
