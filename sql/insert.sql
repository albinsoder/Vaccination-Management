USE vaccineProject;

SET GLOBAL LOCAL_INFILE =true;

SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'patient.csv' 
INTO TABLE patient
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;


LOAD DATA LOCAL INFILE 'vaccine.csv' 
INTO TABLE vaccine
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'medication.csv' 
INTO TABLE medication
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'vaccine2patient.csv' 
INTO TABLE vaccine2patient 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'journal.csv' 
INTO TABLE journal 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'patient2journal.csv' 
INTO TABLE patient2journal 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'medication2patient.csv' 
INTO TABLE medication2patient 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'healthdecleration.csv' 
INTO TABLE health_decleration 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'health2patient.csv' 
INTO TABLE health2patient 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'contact.csv' 
INTO TABLE contact 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;

LOAD DATA LOCAL INFILE 'booking.csv' 
INTO TABLE booking 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
LINES 
    TERMINATED BY '\n'
IGNORE 1 ROWS
;



INSERT INTO admin(username, pass, role)
VALUES("admin", md5("pass12345"), "admin");

INSERT INTO user(username, pass, role)
VALUES("user1", md5("pass12345"), "user");



