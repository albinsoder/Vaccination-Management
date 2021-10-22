use vaccineProject;
drop table if exists admin;
drop table if exists user;
drop table if exists booking;
drop table if exists contact;
drop table if exists patient2journal;
drop table if exists vaccine2patient;
drop table if exists medication2patient;
drop table if exists health2patient;
drop table if exists vaccine;
drop table if exists journal;
drop table if exists patient;
drop table if exists medication;
drop table if exists health_decleration;


create table admin(
    id int AUTO_INCREMENT NOT NULL,
    username varchar(50),
    pass varchar(50),
    role char(10),

    
    PRIMARY KEY(id)

)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table user(
    id int AUTO_INCREMENT NOT NULL,
    username varchar(50),
    pass varchar(50),
    role char(10),

    
    PRIMARY KEY(id)

)
engine innodb
charset utf8
collate utf8_swedish_ci;


create table medication(
    id int AUTO_INCREMENT NOT NULL,
    name varchar(100),
	dose char(10),
    start date,
    end date,

    PRIMARY KEY(id)

)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table health_decleration(
    id int AUTO_INCREMENT NOT NULL,
    reaction varchar(20),
    allergies varchar(20),
    blood_thinning varchar(20),
    pregnant varchar(20),
    recently_vaccinated varchar(20),
    date date,
    
    PRIMARY KEY(id)

)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table vaccine(
    id int AUTO_INCREMENT,
    vaccine_name char(20),
    dose int(2),
    arm char(5),
    date date,

    PRIMARY KEY(id)

)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table patient(
    id int AUTO_INCREMENT NOT NULL,
    firstname char(20),
    surname char(20),
    born int NOT NULL,
    security_number int(4) NOT NULL,
    gender char(6),

    PRIMARY KEY(id)
    
)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table journal(
    id int AUTO_INCREMENT NOT NULL,
	date datetime,
    title varchar(20),
    note varchar(200),

    PRIMARY KEY(id)
    
)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table vaccine2patient(
    id int AUTO_INCREMENT NOT NULL,
    vaccine_id int NOT NULL, 
    patient_id int NOT NULL,

    PRIMARY KEY(id),
	FOREIGN KEY(vaccine_id) REFERENCES vaccine(id),
    FOREIGN KEY(patient_id) REFERENCES patient(id)
    
)
engine innodb
charset utf8
collate utf8_swedish_ci;



create table patient2journal(
    id int AUTO_INCREMENT,
    patient_id int NOT NULL,
    journal_id int NOT NULL,

    PRIMARY KEY(id),
    FOREIGN KEY(patient_id) REFERENCES patient(id),
    FOREIGN KEY(journal_id) REFERENCES journal(id)

    
)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table medication2patient(
    id int AUTO_INCREMENT,
    patient_id int NOT NULL,
    medication_id int NOT NULL,

    PRIMARY KEY(id),
    FOREIGN KEY(patient_id) REFERENCES patient(id),
    FOREIGN KEY(medication_id) REFERENCES medication(id)

    
)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table health2patient(
    id int AUTO_INCREMENT,
    patient_id int NOT NULL,
    health_id int NOT NULL,

    PRIMARY KEY(id),
    FOREIGN KEY(patient_id) REFERENCES patient(id),
    FOREIGN KEY(health_id) REFERENCES health_decleration(id)

    
)
engine innodb
charset utf8
collate utf8_swedish_ci;


create table contact(
    id int AUTO_INCREMENT,
    patient_id int,
    patient_number int(20) NOT NULL,
	adress varchar(20),
	contact_person varchar(20),
    contact_number int(20) NOT NULL,
    
    PRIMARY KEY(id),
    FOREIGN KEY(patient_id) REFERENCES patient(id)

)
engine innodb
charset utf8
collate utf8_swedish_ci;

create table booking(
	id int NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    type varchar(20),
    date DATE NOT NULL,
    start TIME NOT NULL,
    end TIME NOT NULL,

    PRIMARY KEY(id),
    FOREIGN KEY(patient_id) REFERENCES patient(id)
    
)
engine innodb
charset utf8
collate utf8_swedish_ci;

-- Display all the patients
DROP PROCEDURE IF EXISTS show_patients;
DELIMITER ;;

CREATE PROCEDURE show_patients(
)
BEGIN
    SELECT
    id,
	firstname AS Firstname,
    surname AS Surname,
    born AS Born,
    security_number AS SecurityNumber,
    gender AS Gender
    FROM patient
;
END
;;
DELIMITER ;

-- Search for specific patients
DROP PROCEDURE IF EXISTS search_patients;
DELIMITER ;;

CREATE PROCEDURE search_patients(
    search varchar(20)
)
BEGIN
    
    SELECT
    id,
	firstname AS Firstname,
    surname AS Surname,
    security_number AS SecurityNumber,
    born AS Born,
	gender AS Gender
    FROM patient
    WHERE
    firstname LIKE search OR
    surname LIKE search OR
    security_number = search OR
    born = search OR
    gender = search
;
END
;;
DELIMITER ;

-- Get the patient information
DROP PROCEDURE IF EXISTS patient_info;
DELIMITER ;;
CREATE PROCEDURE patient_info(
    personal_id int
)
BEGIN
    SELECT
    id AS Id,
    CONCAT(surname,' ', firstname, ' (', gender,')') AS NameInfo,
    CONCAT(born, '-', security_number, ' (', TIMESTAMPDIFF(YEAR, born, CURDATE()), ') ') AS PersonInfo 
    
    FROM patient
    WHERE
		id = personal_id
	
    
;
END
;;
DELIMITER ;

-- Get the personal journal
DROP PROCEDURE IF EXISTS patient_journal;
DELIMITER ;;
CREATE PROCEDURE patient_journal(
    personal_id int
)
BEGIN
    SELECT
    p.id AS Id,
	DATE_FORMAT(j.date, "%d/%m/%Y-%h:%i") AS Date,    
    j.title AS Title
    FROM journal AS j
		INNER JOIN patient2journal as p2j
			ON j.id = p2j.journal_id
		INNER JOIN patient as p
			ON p2j.patient_id = p.id
    WHERE 
    p.id = personal_id
    ORDER BY Date DESC


;
END
;;
DELIMITER ;

-- Get patient note
DROP PROCEDURE IF EXISTS get_note;
DELIMITER ;;
CREATE PROCEDURE get_note(
    chosen_title varchar(20),
    personal_id int

)
BEGIN
    SELECT
    j.note AS Note
    FROM journal AS j
		INNER JOIN patient2journal as p2j
			ON j.id = p2j.journal_id
		INNER JOIN patient as p
			ON p2j.patient_id = p.id
    WHERE 
    title = chosen_title AND
    p.id = personal_id
;
END
;;
DELIMITER ;

-- Create note
DROP PROCEDURE IF EXISTS create_note;
DELIMITER ;;
CREATE PROCEDURE create_note(
    create_title varchar(20),
    create_note varchar(200),
    create_date datetime,
    personal_id int

)
BEGIN
	
    INSERT INTO journal(date, title, note)
    VALUES(create_date, create_title, create_note);
    
    
    INSERT INTO patient2journal(patient_id, journal_id)
	Values(personal_id, (select id FROM journal WHERE date = create_date AND title = create_title AND note = create_note))

    
;
END
;;
DELIMITER ;

-- Get medication for patient
DROP PROCEDURE IF EXISTS get_medication;
DELIMITER ;;
CREATE PROCEDURE get_medication(
    personal_id int
)
BEGIN
	SELECT 
    m.name as Name,
    CONCAT(m.dose, ' mg') as Dose,
    DATE_FORMAT(m.start, "%d/%m/%Y") AS Start,
    DATE_FORMAT(m.end, "%d/%m/%Y") AS End,
    currently_active(m.end) AS Active
    FROM
    medication as m
		INNER JOIN medication2patient as m2p
			ON m.id = m2p.medication_id
		INNER JOIN patient as p
			ON m2p.patient_id = p.id
	WHERE m2p.patient_id = personal_id
    ORDER BY
	End DESC

;
END
;;
DELIMITER ;

-- Get contactinformation for patient
DROP PROCEDURE IF EXISTS patient_contact;
DELIMITER ;;
CREATE PROCEDURE patient_contact(
    personal_id int
)
BEGIN
	SELECT
    p.id AS Id,
	p.firstname AS Firstname,
    p.surname AS Surname,
    c.patient_number AS PhoneNumber,
	c.adress AS Adress,
    c.contact_person AS ContactPerson,
    c.contact_number AS ContactNumber
    FROM
    patient as p
		INNER JOIN contact as c
			ON p.id = c.patient_id
	WHERE c.patient_id = personal_id

;
END
;;
DELIMITER ;

-- Add new medication to patient
DROP PROCEDURE IF EXISTS add_medication;
DELIMITER ;;
CREATE PROCEDURE add_medication(
	chosen_medication varchar(100),
    chosen_dose char(10),
    chosen_start date,
    chosen_end date,
    personal_id int

)
BEGIN

    INSERT INTO medication(name, dose, start, end)
    VALUES(chosen_medication, chosen_dose, chosen_start, chosen_end);
    
    
    INSERT INTO medication2patient(patient_id, medication_id)
	Values(personal_id, (select id FROM medication WHERE name = chosen_medication AND dose = chosen_dose AND start = chosen_start AND end = chosen_end))

    
;
END
;;
DELIMITER ;

-- Get health decleration for patient
DROP PROCEDURE IF EXISTS get_healthdec;
DELIMITER ;;
CREATE PROCEDURE get_healthdec(
    personal_id int
)
BEGIN
	SELECT 
	h.reaction AS Reaction,
    h.allergies AS Allergies,
    h.blood_thinning AS BloodThinning,
    h.pregnant AS Pregnant,
    h.recently_vaccinated AS RecentlyVaccinated,
    DATE_FORMAT(h.date, "%d/%m/%Y") AS Date
    FROM
    health_decleration as h
		INNER JOIN health2patient as h2p
			ON h.id = h2p.health_id
		INNER JOIN patient as p
			ON h2p.patient_id = p.id
	WHERE h2p.patient_id = personal_id
    ORDER BY Date DESC

;
END
;;
DELIMITER ;

-- Create new health decleration for patient
DROP PROCEDURE IF EXISTS create_health;
DELIMITER ;;
CREATE PROCEDURE create_health(
    new_reaction varchar(20),
    new_allergies varchar(20),
    new_bd varchar(20),
    new_pregnant varchar(20),
    new_rv varchar(20),
    new_date date,
    personal_id int
)
BEGIN
	INSERT INTO health_decleration(reaction, allergies, blood_thinning, pregnant, recently_vaccinated, date)
    VALUES(new_reaction, new_allergies, new_bd, new_pregnant, new_rv, new_date);
    
    INSERT INTO health2patient(patient_id, health_id)
    VALUES(personal_id, (SELECT id FROM health_decleration WHERE reaction = new_reaction AND new_allergies = allergies AND date = new_date))

;
END
;;
DELIMITER ;

-- Get patient vaccine
DROP PROCEDURE IF EXISTS get_vaccine;
DELIMITER ;;
CREATE PROCEDURE get_vaccine(
    personal_id int

)
BEGIN
    SELECT
    v.id AS Id,
    v.vaccine_name AS Name,
    v.dose AS Dose,
    v.arm AS Arm,
    DATE_FORMAT(v.date, "%d/%m/%Y") AS Date
    FROM vaccine AS v
		INNER JOIN vaccine2patient as v2p
			ON v.id = v2p.vaccine_id
		INNER JOIN patient as p
			ON v2p.patient_id = p.id
    WHERE 
    v2p.patient_id = personal_id
    ORDER BY
    date DESC
;
END
;;
DELIMITER ;

-- New vaccine for patient
DROP PROCEDURE IF EXISTS new_vaccine;
DELIMITER ;;
CREATE PROCEDURE new_vaccine(
	new_vaccine char(20),
    new_dose int,
    new_arm char(20),
    new_date date,
    personal_id int
)
BEGIN
	INSERT INTO vaccine(vaccine_name, dose, arm, date)
    VALUES(new_vaccine, new_dose, new_arm, new_date);
    
    INSERT INTO vaccine2patient(vaccine_id, patient_id)
    VALUES((SELECT id FROM vaccine WHERE vaccine_name = new_vaccine AND dose = new_dose AND arm = new_arm AND date = new_date), personal_id)

;
END
;;
DELIMITER ;

-- Get the correct user
DROP PROCEDURE IF EXISTS login_admin;
DELIMITER ;;
CREATE PROCEDURE login_admin(
    user varchar(50)
)
BEGIN
    SELECT
    username,
    pass,
    role
    FROM admin
    WHERE
    username = user

;
END
;;
DELIMITER ;

-- Get the correct user
DROP PROCEDURE IF EXISTS login_user;
DELIMITER ;;
CREATE PROCEDURE login_user(
    user varchar(50)
)
BEGIN
    SELECT
    username,
    pass,
    role
    FROM user
    WHERE
    username = user

;
END
;;
DELIMITER ;

-- Function to get active date
DROP FUNCTION IF EXISTS currently_active;
DELIMITER ;;


CREATE FUNCTION currently_active(
    end date

)
RETURNS CHAR(3)
DETERMINISTIC
BEGIN
    IF current_date() > end THEN
        RETURN 'No';
    ELSE
        RETURN 'Yes';


    END IF;
    RETURN NULL;
END
;;

-- Get users
DROP PROCEDURE IF EXISTS get_users;
DELIMITER ;;
CREATE PROCEDURE get_users(
)
BEGIN
    SELECT
    username,
    role,
    id
    FROM 
    user
;
END
;;
DELIMITER ;

-- Get password for user
DROP PROCEDURE IF EXISTS get_pass;
DELIMITER ;;
CREATE PROCEDURE get_pass(
	user_id int
)
BEGIN
    SELECT
    id,
    username,
    role
    FROM 
    user
    WHERE
    id = user_id
;
END
;;
DELIMITER ;

-- Update password for user
DROP PROCEDURE IF EXISTS update_pass;
DELIMITER ;;
CREATE PROCEDURE update_pass(
	user_id int,
    new_pass varchar(20)
)
BEGIN
	
    UPDATE 
    user
    SET
    pass = md5(new_pass)
    WHERE
    id = user_id
;
END
;;
DELIMITER ;

-- Update password for user
DROP PROCEDURE IF EXISTS new_account;
DELIMITER ;;
CREATE PROCEDURE new_account(
	new_user varchar(20),
    new_pass varchar(20),
    new_role varchar(20)
)
BEGIN
	
	INSERT INTO user(username, pass, role)
    VALUES(new_user, md5(new_pass), new_role)
    
;
END
;;
DELIMITER ;

-- Get booking
DROP PROCEDURE IF EXISTS get_booking;
DELIMITER ;;
CREATE PROCEDURE get_booking(
    choosen_date date
)
BEGIN
    SELECT
    p.id AS Id,
    CONCAT(p.surname,' ', p.firstname, ' (', p.gender,')') AS NameInfo,
    CONCAT(p.born, '-', p.security_number, ' (', TIMESTAMPDIFF(YEAR, p.born, CURDATE()), ') ') AS PersonInfo,
    b.type AS Type,
	DATE_FORMAT(b.date, "%d/%m/%Y") AS Date,
    DATE_FORMAT(b.start, "%h:%i") AS Start,
    DATE_FORMAT(b.end, "%h:%i") AS End
    FROM patient AS p
		INNER JOIN booking as b
			ON p.id = b.patient_id

    WHERE 
	Date = choosen_date

;
END
;;
DELIMITER ;