@echo off
setlocal

set "VENV_PATH=%VENV_PATH%"
if "%VENV_PATH%"=="" set "VENV_PATH=.venv"
set "HOST=%HOST%"
if "%HOST%"=="" set "HOST=0.0.0.0"
set "PORT=%PORT%"
if "%PORT%"=="" set "PORT=8000"
set "BOOTSTRAP=%BOOTSTRAP%"
if "%BOOTSTRAP%"=="" set "BOOTSTRAP=1"
set "RESTART_EXISTING=%RESTART_EXISTING%"
if "%RESTART_EXISTING%"=="" set "RESTART_EXISTING=1"

where uv >nul 2>nul
if errorlevel 1 (
  echo [ERROR] 未找到 uv 命令。请先安装 uv，并确保 uv 可在终端中使用。
  exit /b 1
)

cd /d "%~dp0"
echo [INFO] 项目目录: %CD%
echo [INFO] 使用 uv 虚拟环境目录: %VENV_PATH%
echo [INFO] 启动后端: http://localhost:%PORT%
echo [INFO] 按 Ctrl+C 可停止服务

if "%RESTART_EXISTING%"=="1" (
  echo [INFO] 启动前先清理旧的后端 / Solver 进程
  powershell -ExecutionPolicy Bypass -File "%~dp0stop_backend.ps1" -BackendPort %PORT% -SolverPort 8889 -FullStop 0
)

set "PYTHON_EXE=%CD%\%VENV_PATH%\Scripts\python.exe"

if not exist "%PYTHON_EXE%" (
  if "%BOOTSTRAP%"=="0" (
    echo [ERROR] 未检测到虚拟环境: %PYTHON_EXE%。请先执行 uv venv %VENV_PATH% 或设置 BOOTSTRAP=1。
    exit /b 1
  )
  echo [INFO] 未检测到虚拟环境，正在创建: %VENV_PATH%
  uv venv %VENV_PATH%
)

if "%BOOTSTRAP%"=="1" (
  echo [INFO] 正在同步后端依赖 (uv pip install -r requirements.txt)
  uv pip install --python "%PYTHON_EXE%" -r requirements.txt
)

if not exist "%PYTHON_EXE%" (
  echo [ERROR] 无法解析 uv 虚拟环境对应的 python 路径: %PYTHON_EXE%
  exit /b 1
)

set "HOST=%HOST%"
set "PORT=%PORT%"
for %%I in ("%CD%\%VENV_PATH%") do set "APP_PYTHON_ENV=%%~nxI"
echo [INFO] Python: %PYTHON_EXE%
"%PYTHON_EXE%" main.py
