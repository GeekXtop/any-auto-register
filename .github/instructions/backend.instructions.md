---
description: "Use when: editing backend Python code in api/core/services/platforms/tests; covers plugin contracts, task runtime control, config fallback, and minimal-change practices."
name: "Backend Python Guidelines"
applyTo: "main.py, api/**/*.py, core/**/*.py, services/**/*.py, platforms/**/*.py, tests/**/*.py"
---
# Backend Guidelines

- 保持分层边界清晰：`api/` 做编排，`core/` 放抽象与基础设施，`services/` 放跨平台服务逻辑，`platforms/` 放具体平台实现。
- 新平台必须继承 `BasePlatform`，声明 `name`、`display_name`，并使用 `@register` 注册；实现 `register` 与 `check_valid`。
- 不绕过任务控制：涉及等待、轮询、跳过/停止时，遵循 `core/task_runtime.py` 的协作式中断机制。
- 配置读取优先兼容 `core/config_store.py`：支持 `.env` + 运行时环境变量回退，不引入孤立配置来源。
- 代理能力复用 `core/proxy_pool.py` / `core/proxy_utils.py`，避免重复实现轮询、禁用、上报。
- 邮箱能力遵循 `core/base_mailbox.py` 接口（`get_email`、`wait_for_code`），不要在平台里硬编码单一邮箱服务流程。
- 改动最小化：优先局部修复，不做与任务无关的重构或大规模重命名。

## Validation

- 优先运行相关测试：`python -m unittest discover -s tests -p "test_*.py"`。
- 涉及后端启动/求解器问题时，优先按 Windows 推荐脚本 `start_backend.ps1` 验证运行路径。
- 详细运行与部署说明请链接 `README.md`，避免在回答中重复粘贴长文档。
