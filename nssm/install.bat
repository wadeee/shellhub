@echo off
setlocal

:: 1. 检查管理员权限，如果需要则自我提升
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
echo Running with administrative privileges.
echo.

:: 设置zip文件的相对路径
set "ZIP_FILE=%~dp0nssm-2.24.zip"

:: 2. 解压文件到 C:\
echo --- Unzipping %ZIP_FILE% to C:\ ---
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath 'C:\' -Force"
if %errorlevel% neq 0 (
    echo ERROR: Failed to unzip the file. Make sure '%ZIP_FILE%' exists.
    pause
    exit /b
)
echo Unzip successful.
echo.

:: 3. 根据操作系统架构确定正确的 nssm 目录
IF EXIST "%ProgramFiles(x86)%" (
  set "NSSM_DIR=C:\nssm-2.24\win64"
) ELSE (
  set "NSSM_DIR=C:\nssm-2.24\win32"
)
echo Detected architecture-specific path: %NSSM_DIR%
echo.

:: 4. 永久添加目录到系统 PATH 环境变量
echo --- Adding to system PATH ---
echo This will add '%NSSM_DIR%' to the system PATH if it's not already there.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    $envPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine'); ^
    $parts = $envPath -split ';'; ^
    $nssmPath = '%NSSM_DIR%'; ^
    if (-not ($parts -contains $nssmPath)) { ^
        $newPath = $envPath.TrimEnd(';') + ';' + $nssmPath; ^
        [System.Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine'); ^
        Write-Host "'%NSSM_DIR%' has been added to the system PATH."; ^
        Write-Host "You may need to restart your terminal for the changes to take effect."; ^
    } else { ^
        Write-Host "'%NSSM_DIR%' is already in the system PATH."; ^
    }

if %errorlevel% neq 0 (
    echo ERROR: Failed to update the system PATH.
    pause
    exit /b
)

echo.
echo --- Installation complete! ---
pause
endlocal
