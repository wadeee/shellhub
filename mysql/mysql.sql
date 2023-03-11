-- create database
CREATE SCHEMA `dbname`;

-- drop database
DROP SCHEMA `dbname`;

-- use databse
USE `dbname`;

-- insert
INSERT INTO `dbname` (col1, col2) VALUE ('1', '1');
INSERT INTO `dbname` (col1, col2) VALUES ('1', '1'), ('2', '3');

-- update
UPDATE `dbname` SET col1='3', col2='3' WHERE col1='1';

-- delete
DELETE FROM `dbname` WHERE col1='1';

-- import
SOURCE /root/temp/target.sql;
