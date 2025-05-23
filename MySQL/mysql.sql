-- update low policy password
-- cat /var/log/mysqld.log
ALTER USER USER() IDENTIFIED BY "Password.1";
SHOW VARIABLES LIKE 'validate_password%';
SET GLOBAL validate_password.policy = LOW;
ALTER USER USER() IDENTIFIED BY "password";

-- enable root remote login
USE mysql;
UPDATE user SET host='%' WHERE user ='root';
FLUSH PRIVILEGES;

-- show root's hosts
USE mysql;
SELECT host, user, authentication_string, plugin FROM user;

-- disable root remote login
USE mysql;
UPDATE user SET host='localhost' WHERE user ='root';
FLUSH PRIVILEGES;

-- update password & enable root remote login
USE mysql;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
FLUSH PRIVILEGES;

-- create database
CREATE SCHEMA `dbname`;

-- drop database
DROP SCHEMA `dbname`;

-- use databse
USE `dbname`;

-- create table
CREATE TABLE `dbname` (
  `col1` VARCHAR(255) NOT NULL,
  `col2` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`col1`)
);

-- drop table
DROP TABLE `dbname`;

-- rename table
RENAME TABLE `dbname` TO `new-dbname`;

-- show schemas;
SHOW SCHEMAS;

-- add column
ALTER TABLE `dbname` ADD COLUMN `col1` VARCHAR(255) NOT NULL;

-- drop column
ALTER TABLE `dbname` DROP COLUMN `col1`;

-- rename column
ALTER TABLE `dbname` CHANGE COLUMN `col1` `new-col1` VARCHAR(255) NOT NULL;

-- import
SOURCE /root/temp/target.sql;

-- insert
INSERT INTO `dbname` (col1, col2) VALUE ('1', '1');
INSERT INTO `dbname` (col1, col2) VALUES ('1', '1'), ('2', '3');

-- update
UPDATE `dbname` SET col1='3', col2='3' WHERE col1='1';

-- delete
DELETE FROM `dbname` WHERE col1='1';
