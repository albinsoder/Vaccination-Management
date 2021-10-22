CALL show_patients();
SELECT * FROM patient;
SELECT * FROM admin;
SELECT * FROM journal;

INSERT INTO journal(date, title, note)
VALUES("2020-05-05", "hej", "hej hej");


SELECT * FROM patient2journal;
CALL patient_journal(1);
CALL patient_info(1);
CALL get_note("asd");
CALL login("hansve1998@gmail.com");

CALL create_note("hej", "hej hej", "2020-05-05-09:30", 1);

select id FROM journal WHERE date = "2020-05-05" AND title = "hej" AND note = "hej hej";

SELECT * FROM medication;
 CALL get_medication(1); 
CALL add_medication("alvedon", "400", "2021-10-05", "2021-10-10", 2);
CALL new_vaccine("pfizer", "3", "right", "2021-10-10","2");
CALL get_booking("2021-10-18");
SELECT * FROM booking;
CALL get_healthdec(2);
CALL get_users();

CALL update_pass(1, "hej123");