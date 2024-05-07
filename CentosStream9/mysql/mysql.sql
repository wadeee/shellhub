-- update password
ALTER USER USER() IDENTIFIED BY "Password.1";
SET GLOBAL validate_password.policy = LOW;
ALTER USER USER() IDENTIFIED BY "password";
