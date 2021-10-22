DROP DATABASE vaccineProject;
CREATE DATABASE IF NOT EXISTS vaccineProject;

USE vaccineProject;
SHOW DATABASES LIKE "%vaccineProject%";

CREATE USER IF NOT EXISTS 'user'@'%'
    IDENTIFIED
    WITH mysql_native_password 
    BY 'pass'
;

GRANT ALL PRIVILEGES
    ON *.*
    TO 'user'@'%'
;
SHOW GRANTS FOR 'user'@'%';