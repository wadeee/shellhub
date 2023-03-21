@echo off
echo.
echo initialize MySQL
echo.

echo copy mysql config
copy %~dp0my.ini "C:\Program Files\MySQL\MySQL Server 8.0\my.ini"

echo initialize mysqld
mysqld --initialize --console

echo install mysqld as service
mysqld --install

echo start mysqld service
net start mysql

pause
