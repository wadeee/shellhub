@echo off
echo.
echo initialize MySQL
echo.

echo stop mysqld service
net stop mysql

echo remove mysqld service
mysqld --remove

echo copy mysql config
copy %~dp0my.ini "C:\Program Files\MySQL\MySQL Server 8.0\my.ini"

echo remove data folder
rmdir /s /q "C:\Program Files\MySQL\MySQL Server 8.0\data"

echo initialize mysqld
mysqld --initialize --console

echo install mysqld as service
mysqld --install

echo start mysqld service
net start mysql

pause
