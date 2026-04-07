param(
    [string]$VenvPath = ".venv",
    [string]$BindHost = "0.0.0.0",
    [int]$Port = 8000,
    [switch]$Bootstrap = $true,
    [switch]$RestartExisting = $true
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$uv = Get-Command uv -ErrorAction SilentlyContinue
if (-not $uv) {
    Write-Error "未找到 uv 命令。请先安装 uv，并确保 uv 可在终端中使用。"
    exit 1
}

Write-Host "[INFO] 项目目录: $root"
Write-Host "[INFO] 使用 uv 虚拟环境目录: $VenvPath"
$displayHost = if ($BindHost -eq "0.0.0.0") { "localhost" } else { $BindHost }
Write-Host "[INFO] 启动后端: http://$displayHost`:$Port"
Write-Host "[INFO] 按 Ctrl+C 可停止服务"

if ($RestartExisting) {
    Write-Host "[INFO] 启动前先清理旧的后端 / Solver 进程"
    & "$root\stop_backend.ps1" -BackendPort $Port -SolverPort 8889 -FullStop 0
}

$venvDir = Join-Path $root $VenvPath
$pythonExe = Join-Path $venvDir "Scripts\python.exe"

if (-not (Test-Path $pythonExe)) {
    if (-not $Bootstrap) {
        Write-Error "未检测到虚拟环境: $pythonExe。请先执行 'uv venv $VenvPath' 或启用 -Bootstrap。"
        exit 1
    }
    Write-Host "[INFO] 未检测到虚拟环境，正在创建: $VenvPath"
    & uv venv $VenvPath
}

if ($Bootstrap) {
    Write-Host "[INFO] 正在同步后端依赖 (uv pip install -r requirements.txt)"
    & uv pip install --python $pythonExe -r requirements.txt
}

$env:HOST = $BindHost
$env:PORT = [string]$Port
$env:APP_PYTHON_ENV = [IO.Path]::GetFileName($venvDir)

Write-Host "[INFO] Python: $pythonExe"
& $pythonExe main.py
