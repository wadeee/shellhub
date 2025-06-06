@echo off
cd /d %~dp0
rmdir /s /q "C:\ProgramData\ZeroTier\One\moons.d"
mkdir "C:\ProgramData\ZeroTier\One\moons.d"
copy ".\planet" "C:\ProgramData\ZeroTier\One\"
copy ".\000000ec93aa2db6.moon" "C:\ProgramData\ZeroTier\One\moons.d\"
pause
