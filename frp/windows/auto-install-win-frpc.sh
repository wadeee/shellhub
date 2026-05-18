#!/bin/sh

unzip -o ./frp_0.68.1_windows_amd64.zip -d /C/
cp ./frpc.bat C:/frp_0.68.1_windows_amd64/
cp ./frpc.yaml C:/frp_0.68.1_windows_amd64/
nssm stop frpc
nssm remove frpc
nssm install frpc
nssm start frpc
