#!/bin/sh

nssm stop frpc
nssm remove frpc
rm -rf /C/frp_0.68.1_windows_amd64/
unzip -o ./frp_0.68.1_windows_amd64.zip -d /C/
cp ./frpc.bat /C/frp_0.68.1_windows_amd64/
cp ./frpc.yaml /C/frp_0.68.1_windows_amd64/
nssm install frpc "C:\\frp_0.68.1_windows_amd64\\frpc.bat"
nssm start frpc
