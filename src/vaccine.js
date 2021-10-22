"use strict";

/*These funcions are used to create a 
connection to the database and make queries */

module.exports = {
    patientVaccine: patientVaccine,
    checkUser: checkUser,
    showPatient: showPatient,
    searchPatient: searchPatient,
    patientInfo: patientInfo,
    patientInfoTitle: patientInfoTitle,
    createNote: createNote,
    patientInfoMedication: patientInfoMedication,
    addMedication: addMedication,
    healthDecleration: healthDecleration,
    createHealth: createHealth,
    patientContact: patientContact,
    pateintInfoVaccine: pateintInfoVaccine,
    getBooking:getBooking,
    getUsers: getUsers,
    checkAdmin: checkAdmin,
    getPass: getPass,
    updatePass: updatePass,
    newAccount: newAccount
};

const { createConnection } = require("mysql");
const mysql  = require("promise-mysql");
const config = require("../config/vaccine.json");

async function checkUser(username) {
    const db = await mysql.createConnection(config);
    let sql = `CALL login_user(?);`;
    let res = await db.query(sql, [username]);

    db.end();
    return res[0];

}
async function checkAdmin(username) {
    const db = await mysql.createConnection(config);
    let sql = `CALL login_admin(?);`;
    let res = await db.query(sql, [username]);
    db.end();

    return res[0];

}

async function getPass(id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_pass(?);`;
    let res = await db.query(sql, [id]);
    db.end();

    return res[0];

}

async function showPatient() {
    const db = await mysql.createConnection(config);
    let sql = `CALL show_patients();`;
    let res = await db.query(sql);
    db.end();

    return res[0];
}

async function searchPatient(search) {
    const db = await mysql.createConnection(config);
    let sql = `CALL search_patients(?);`;
    let res = await db.query(sql, [search])
    db.end();

    return res[0];
}

async function healthDecleration(id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL get_healthdec(?);`;
    let res = await db.query(sql, [id, id]);
    db.end();

    return res;
}

async function patientInfo(id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL patient_journal(?); CALL get_note(?,?);`;
    let res = await db.query(sql, [id, id, id, id]);
    db.end();

    return res;
}

async function patientInfoTitle(id, title) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL patient_journal(?); CALL get_note(?,?);`;
    let res = await db.query(sql, [id, id, title, id]);
    db.end();

    return res;
}

async function patientInfoMedication(id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL get_medication(?);`
    let res = await db.query(sql, [id, id]);
    db.end();

    return res;
}

async function pateintInfoVaccine(id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL get_vaccine(?);`
    let res = await db.query(sql, [id, id]);
    db.end();

    return res;
}

async function patientVaccine(id, vaccine, dose, arm, date) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL get_vaccine(?); CALL new_vaccine(?,?,?,?,?);`
    let res = await db.query(sql, [id, id, vaccine, dose, arm, date, id]);
    db.end();

    return res;
}

async function createNote(title, note, date, id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL patient_journal(?); CALL get_note(?,?); CALL create_note(?,?,?,?);`;
    let res = await db.query(sql, [id, id, title, id, title, note, date,id ]);
    db.end();

    return res;
}

async function createHealth(id, reaction, allergies, blood_thinning, pregnant, recently, date){
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL get_healthdec(?); CALL create_health(?,?,?,?,?,?,?);`;
    let res = await db.query(sql, [id, id, reaction, allergies, blood_thinning, pregnant, recently, date, id]);
    db.end();

    return res;

}

async function addMedication(id, medication, dose, start, end) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_info(?); CALL get_medication(?); CALL add_medication(?,?,?,?,?);`;
    let res = await db.query(sql, [id, id, medication, dose, start,end, id]);
    db.end();

    return res;
}

async function patientContact(id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL patient_contact(?);`;
    let res = await db.query(sql, [id]);
    db.end();

    return res;
}
async function getBooking(date) {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_booking(?);`;
    let res = await db.query(sql, [date]);
    db.end();

    return res;
}

async function getUsers() {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_users();`;
    let res = await db.query(sql);
    db.end();

    return res;
}

async function updatePass(id, pass) {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_users(); CALL update_pass(?,?);`;
    let res = await db.query(sql, [id, pass]);
    db.end();

    return res;
}
async function newAccount(user, pass, role) {
    const db = await mysql.createConnection(config);
    let sql = `CALL new_account(?,?,?);`;
    let res = await db.query(sql, [user, pass, role]);
    db.end();

    return res;
}


