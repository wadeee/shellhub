-- update password
ALTER USER USER() IDENTIFIED BY "password";

-- show root's hosts
USE mysql;
SELECT host, user, authentication_string, plugin FROM user;

-- enable root remote login
USE mysql;
UPDATE user SET host='%' WHERE user ='root';
FLUSH PRIVILEGES;

-- disable root remote login
USE mysql;
UPDATE user SET host='localhost' WHERE user ='root';
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


## enable root remote login ##
# use mysql;
# select host, user, authentication_string, plugin from user;
# update user set host='%' where user ='root';
# update user set host='localhost' where user ='root'; ## disable root remote login
# flush privileges;

## update password & enable root remote login ##
# alter user user() identified by "password"; use mysql; update user set host='%' where user ='root'; flush privileges;

## add user
# create user ry@'%' identified by 'cellxiot654321';
# grant all privileges on ry-vue.* to ry@'%';
