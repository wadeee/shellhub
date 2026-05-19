@echo off
setlocal

:: 1. 检查并请求管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
echo Running with administrative privileges.
echo.

:: 2. 运行安装脚本
echo --- Running frpc installation script ---
cd /d %~dp0
sh auto-install-win-frpc.sh
if %errorlevel% neq 0 (
    echo ERROR: The installation script failed.
    pause
    exit /b
)

echo.
echo --- frpc installation complete! ---
pause
endlocal
