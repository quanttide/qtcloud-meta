# lite

量潮元云的微信小程序，基于 Taro 4、React 与 TypeScript，构建产物输出到 `dist/`，由微信开发者工具导入运行。定位是**只读展示**——范畴的维护在 studio（见 [`docs/dev-guide/studio.md`](../../docs/dev-guide/studio.md)），小程序不写任何东西。

## 页面

- 首页：入口清单；
- 标准范畴：两个九宫格 18 格 + Context、Archive 的只读展示。数据摘录自正本《量潮标准范畴》（元工程案例集 `docs/gallery/metaphysics/category/index.md`），正本改了随改。

## 命令

```bash
npm run dev:weapp    # 监听构建
npm run build:weapp  # 构建产物到 dist/
```

## 上架准备

1. 在微信公众平台注册小程序并取得 AppID，替换 `project.config.json` 中的 `appid`，当前占位值为 `touristappid`，替换后需重新执行构建。
2. 用微信开发者工具导入本目录，工具按 `project.config.json` 的 `miniprogramRoot` 指向 `dist/` 预览与调试。
3. 在小程序后台配置服务器域名；当前页面纯本地数据，无请求，真机不需合法域名。
4. 选定服务类目并填写《用户隐私保护指引》。
5. 上传体验版供内部验收，再提交审核；审核通过后发布，后续版本沿用同一 AppID 迭代。

## 发布（惯例，CI 待配）

按子包惯例打 tag：`lite/vX.Y.Z`；子包版本见本目录 [`CHANGELOG.md`](CHANGELOG.md)，仓库级变更才进根 CHANGELOG。CI（`npm ci` → `npm run build:weapp` → miniprogram-ci 上传体验版）随首次发版配置，密钥三项：`MINIPROGRAM_PRIVATE_KEY` / `MINIPROGRAM_APPID` / `MINIPROGRAM_ROBOT`。
