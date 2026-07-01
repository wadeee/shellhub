@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

set "PROXY_SOCKS=socks5h://localhost:7890"
set "PROXY_HTTP=http://localhost:7890"

echo [INFO] ========================================
echo [INFO] Proxy Environment Variable Setup Script
echo [INFO] ========================================
echo [INFO] SOCKS Proxy : %PROXY_SOCKS%
echo [INFO] HTTP  Proxy : %PROXY_HTTP%
echo.

:: Check admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARN] Not running as Administrator, requesting elevation...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo [INFO] Running with Administrator privileges.
echo.

:: Set machine-level environment variables
echo [INFO] Setting all_proxy = %PROXY_SOCKS% ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('all_proxy', '%PROXY_SOCKS%', 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   all_proxy set successfully.
) else (
    echo [FAIL] Failed to set all_proxy.
)

echo [INFO] Setting http_proxy = %PROXY_HTTP% ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('http_proxy', '%PROXY_HTTP%', 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   http_proxy set successfully.
) else (
    echo [FAIL] Failed to set http_proxy.
)

echo [INFO] Setting https_proxy = %PROXY_HTTP% ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('https_proxy', '%PROXY_HTTP%', 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   https_proxy set successfully.
) else (
    echo [FAIL] Failed to set https_proxy.
)

echo [INFO] Setting ftp_proxy = %PROXY_HTTP% ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('ftp_proxy', '%PROXY_HTTP%', 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   ftp_proxy set successfully.
) else (
    echo [FAIL] Failed to set ftp_proxy.
)

:: Also set for current session so it takes effect immediately
set "all_proxy=%PROXY_SOCKS%"
set "http_proxy=%PROXY_HTTP%"
set "https_proxy=%PROXY_HTTP%"
set "ftp_proxy=%PROXY_HTTP%"

echo.
echo [INFO] ========================================
echo [INFO] Verifying machine-level proxy settings:
echo [INFO] ========================================
for %%V in (all_proxy http_proxy https_proxy ftp_proxy) do (
    for /f "usebackq tokens=*" %%R in (`powershell -Command "[System.Environment]::GetEnvironmentVariable('%%V', 'Machine')"`) do (
        if "%%R"=="" (
            echo [WARN] %%V = ^(not set^)
        ) else (
            echo [OK]   %%V = %%R
        )
    )
)

echo.
echo [INFO] Done. New processes will pick up the proxy settings.
echo [INFO] Existing terminals need to be reopened to use the new settings.
pause
