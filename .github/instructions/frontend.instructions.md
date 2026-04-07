---
description: "Use when: editing frontend React/TypeScript files under frontend/src; covers API integration, routing/UI consistency, and Vite proxy/build conventions."
name: "Frontend React Guidelines"
applyTo: "frontend/src/**/*.ts, frontend/src/**/*.tsx, frontend/vite.config.ts"
---
# Frontend Guidelines

- 技术栈固定为 React + TypeScript + Vite，保持现有目录职责：`pages/` 页面、`components/` 组件、`hooks/` 逻辑复用、`lib/` 工具与请求封装。
- 与后端交互默认走 `/api` 前缀，遵循 `frontend/vite.config.ts` 的开发代理约定，不硬编码非必要绝对地址。
- UI 组件优先复用现有模式（Ant Design + 既有样式结构），避免在单次任务里引入新状态管理或新 UI 框架。
- 保持 TypeScript 类型完整，避免 `any` 扩散；接口字段命名与后端返回保持一致。
- 变更应聚焦业务目标：避免顺手改大段样式、路由结构或无关页面。

## Validation

- 本地开发验证：`frontend/` 下 `npm run dev`。
- 交付前至少通过构建：`frontend/` 下 `npm run build`（输出到根目录 `static/`）。
- 前端模板或工具链细节请链接 `frontend/README.md`，不要重复内嵌模板说明。
