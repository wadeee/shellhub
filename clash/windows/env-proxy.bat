@echo off
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force"
powershell -Command "[System.Environment]::SetEnvironmentVariable('all_proxy', 'socks5h://localhost:7890', 'Machine')"
powershell -Command "[System.Environment]::SetEnvironmentVariable('http_proxy', 'http://localhost:7890', 'Machine')"
powershell -Command "[System.Environment]::SetEnvironmentVariable('https_proxy', 'http://localhost:7890', 'Machine')"
powershell -Command "[System.Environment]::SetEnvironmentVariable('ftp_proxy', 'http://localhost:7890', 'Machine')"
pause
