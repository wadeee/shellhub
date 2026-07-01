@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

echo [INFO] ========================================
echo [INFO] Proxy Environment Variable Remove Script
echo [INFO] ========================================
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

:: Show current values before removal
echo [INFO] Current machine-level proxy settings:
for %%V in (all_proxy http_proxy https_proxy ftp_proxy) do (
    for /f "usebackq tokens=*" %%R in (`powershell -Command "[System.Environment]::GetEnvironmentVariable('%%V', 'Machine')"`) do (
        if "%%R"=="" (
            echo [INFO] %%V = ^(not set^)
        ) else (
            echo [INFO] %%V = %%R
        )
    )
)
echo.

:: Remove machine-level environment variables
echo [INFO] Removing all_proxy ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('all_proxy', $null, 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   all_proxy removed successfully.
) else (
    echo [FAIL] Failed to remove all_proxy.
)

echo [INFO] Removing http_proxy ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('http_proxy', $null, 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   http_proxy removed successfully.
) else (
    echo [FAIL] Failed to remove http_proxy.
)

echo [INFO] Removing https_proxy ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('https_proxy', $null, 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   https_proxy removed successfully.
) else (
    echo [FAIL] Failed to remove https_proxy.
)

echo [INFO] Removing ftp_proxy ...
powershell -Command "[System.Environment]::SetEnvironmentVariable('ftp_proxy', $null, 'Machine')"
if %errorlevel% equ 0 (
    echo [OK]   ftp_proxy removed successfully.
) else (
    echo [FAIL] Failed to remove ftp_proxy.
)

:: Clear current session
set "all_proxy="
set "http_proxy="
set "https_proxy="
set "ftp_proxy="

echo.
echo [INFO] ========================================
echo [INFO] Verifying removal:
echo [INFO] ========================================
for %%V in (all_proxy http_proxy https_proxy ftp_proxy) do (
    for /f "usebackq tokens=*" %%R in (`powershell -Command "[System.Environment]::GetEnvironmentVariable('%%V', 'Machine')"`) do (
        if "%%R"=="" (
            echo [OK]   %%V = ^(not set^)
        ) else (
            echo [WARN] %%V = %%R ^(still exists!^)
        )
    )
)

echo.
echo [INFO] Done. Proxy environment variables have been removed.
echo [INFO] Existing terminals need to be reopened for changes to take effect.
pause
