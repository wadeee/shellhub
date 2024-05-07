-- update password
ALTER USER USER() IDENTIFIED BY "Password.1";
SHOW VARIABLES LIKE 'validate_password%';
SET GLOBAL validate_password.policy = LOW;
ALTER USER USER() IDENTIFIED BY "password";
