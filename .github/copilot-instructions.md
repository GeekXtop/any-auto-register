# any-auto-register Project Guidelines

## Code Style
- 后端使用 Python 3.12+，前端使用 TypeScript + React（Vite）。
- 保持现有分层与命名风格，不做无关重构。
- 改动优先最小化：仅修改与任务直接相关的文件。
- 新增配置项时，优先兼容 `core/config_store.py` 的环境变量回退机制（`.env` + 运行时环境变量）。

## Architecture
- 后端入口：`main.py`（FastAPI 生命周期内初始化 DB、平台注册、调度器、Solver）。
- API 层：`api/`（路由与请求编排）。
- Core 层：`core/`（抽象基类、注册表、任务运行时、配置存储、数据库模型等）。
- 平台插件层：`platforms/<platform>/plugin.py`，通过 `core.registry.register` 注册。
- 服务层：`services/`（状态同步、外部集成、Turnstile Solver 管理）。
- 前端：`frontend/src/`，Vite 开发代理将 `/api` 转发到 `http://localhost:8000`。

## Build and Test
- 后端（Windows 推荐）：运行仓库根目录的 `start_backend.ps1`。
- 前端开发：在 `frontend/` 运行 `npm run dev`。
- 前端构建：在 `frontend/` 运行 `npm run build`（输出到根目录 `static/`）。
- Docker：在根目录使用 `docker compose up -d --build`。
- Python 测试（unittest）：优先使用 `python -m unittest discover -s tests -p "test_*.py"`。

## Conventions
- 新平台应继承 `core/base_platform.py` 中的 `BasePlatform`，实现 `register` 与 `check_valid`。
- 平台类需声明 `name`、`display_name`，并用 `@register` 装饰器注册。
- 任务控制遵循 `core/task_runtime.py` 协作式中断/跳过机制，避免绕过任务控制直接阻塞。
- 邮箱能力遵循 `core/base_mailbox.py` 抽象接口（`get_email`、`wait_for_code`）。
- 涉及代理逻辑时复用 `core/proxy_pool.py` 与 `core/proxy_utils.py`，不要重复实现轮询与上报。

## Common Pitfalls
- 不在正确环境启动后端会导致 Solver 状态异常；Windows 下优先使用 `start_backend.ps1`。
- Docker 环境下 `APP_CONDA_ENV` 应为 `docker`（见 `docker-compose.yml`），避免环境告警误判。
- 首次环境初始化通常需要 Playwright/Camoufox 依赖，详见 README 的快速开始与 Docker 说明。

## Documentation Map (Link, don’t embed)
- 项目总览与启动排障：`README.md`
- 前端模板说明：`frontend/README.md`
- 专题方案与设计记录：`docs/superpowers/plans/`、`docs/superpowers/specs/`
- 容器部署细节：`docker-compose.yml`、`Dockerfile`
