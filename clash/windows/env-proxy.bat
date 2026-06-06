@echo off

powershell -Command "Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force"

powershell -Command "[Environment]::SetEnvironmentVariable('http_proxy','http://127.0.0.1:7890','Machine')"
powershell -Command "[Environment]::SetEnvironmentVariable('https_proxy','http://127.0.0.1:7890','Machine')"
powershell -Command "[Environment]::SetEnvironmentVariable('all_proxy','socks5://127.0.0.1:7890','Machine')"

echo Proxy configured.
pause
