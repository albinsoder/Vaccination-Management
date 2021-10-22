"use strict";
const express = require("express");
const router  = express.Router();
const vaccine    = require("../src/vaccine.js");
const bodyParser = require("body-parser");
const urlencodedParser = bodyParser.urlencoded({ extended: false });
const md5 = require("md5");
const session = require("cookie-session");

//Creating a new session
router.use(
    session({
        key: "userId",
        secret: "secretsecret",
        resave: false,
        saveUnitilialized: false,
        cookie: {
            expires: 60*60*24*1000
        },
    })
);

//Login
router.get("/vaccine/login", async (req, res) => {
    //If there's a user, changes login to logout so you can't login again
    if(req.session.user) {
        
        res.redirect("../vaccine/logout");
    } else {
        let data = {
            title: "Login"
        };
        res.render("vaccine/login", data);
    }
});

router.post("/vaccine/login", urlencodedParser, async (req, res) => {
    let username = req.body.username;
    let password = req.body.password;
    let result;
    //check if user or admin
    if(username == "admin"){
        result = await vaccine.checkAdmin(username, password);
    }else {
        result = await vaccine.checkUser(username, password);
    }
    //Check if username and password are correct. Password in database is encrypted, so change
    //input-password to encrypted to compare
    if(username == result[0].username && md5(password) == result[0].pass){
        //here i set my cookie = user
        req.session.user = result;
        res.redirect("/index");
    }      
    else{
        //if wrong password i render ther login page again
        //later implemation would include a wrong-message as well
        res.render("/vaccine/login", data);
    }
});

//Logout
router.get("/vaccine/logout", async (req, res) => {
    let data = {
        title: "Logout",
        controll: req.session.user[0].role

    };

    res.render("vaccine/logout", data);
    
});
//Logout
router.post("/vaccine/logout", urlencodedParser, async (req, res) => {
    //Set session = null, you no longer can access any routes
    req.session.user = null;
    res.redirect("../vaccine/login");
});
//Home
router.get("/", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else{
        let data = {
            title: "Log in",
            controll: req.session.user[0].role

        };
        res.render("vaccine/login", data);
    }

});
//Home
router.get("/index", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Log in",
            controll: req.session.user[0].role

        };
        res.render("vaccine/index", data);
    }

});

//Get health decleration history
router.get("/vaccine/health/:id/", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let id = req.params.id;
        let data = {
            title: `Patient HealthDecleration`,
            controll: req.session.user[0].role

        };

        data.res = await vaccine.healthDecleration(id);
        res.render("vaccine/health", data);

    }
});

//Get health decleration Create
router.get("/vaccine/healthdec/:id/", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let id = req.params.id;
        let data = {
            title: `Patient HealthDecleration`,
            controll: req.session.user[0].role

        };

        data.res = await vaccine.healthDecleration(id);
        res.render("vaccine/healthdec", data);

    }
});

//Post health decleration
router.post("/vaccine/healthdec/:id", urlencodedParser, async (req, res) => {

    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Create HealthDec",
            controll: req.session.user[0].role

        }

        let id = req.body.Id
        let reaction = req.body.Reaction;
        let allergies = req.body.Allergies;
        let blood_thinning = req.body.Blood;
        let pregnant = req.body.Pregnant;
        let recently = req.body.Recently;
        let date = req.body.Date;

        data.res = await vaccine.createHealth(id, reaction, allergies, blood_thinning, pregnant, recently, date)
        res.render("vaccine/health", data);
    }
});



//Journal Get for patients
router.get("/vaccine/journal", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else{
        let data = {
            title: "Journal",
            controll: req.session.user[0].role

        };
    
        data.res = await vaccine.showPatient();
        res.render("vaccine/journal", data);
    }
});

//Journal Post for search
router.post("/vaccine/journal/", urlencodedParser, async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Journal",
            controll: req.session.user[0].role

        };
        
        let search = req.body.search;
        if(search == ""){
            data.res = await vaccine.showPatient();
            res.render("vaccine/journal", data);

        } else {
            data.res = await vaccine.searchPatient(req.body.search);
            res.render("vaccine/journal", data);

        }
    }
});

//Patients personal journal
router.get("/vaccine/patient/:id/", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let id = req.params.id;
        let data = {
            title: `Patient Journal`,
            controll: req.session.user[0].role

        };

        data.res = await vaccine.patientInfo(id);
        res.render("vaccine/patient", data);

    }
});

//Patients personal journal with decided note
router.get("/vaccine/patient/:id/:title", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let id = req.params.id;
        let title = req.params.title;
        let data = {
            title: `Patient Journal`,
            controll: req.session.user[0].role

        };
        data.res = await vaccine.patientInfoTitle(id, title);
        res.render("vaccine/patient", data);

    }
});

//Write Note
router.get("/vaccine/write/:id", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Write",
            controll: req.session.user[0].role

        };
        let id = req.params.id;
        data.res = await vaccine.patientInfo(id);
        res.render("vaccine/write", data);
    }
});
//Post Note
router.post("/vaccine/write", urlencodedParser, async (req, res) => {

    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Write",
            controll: req.session.user[0].role

        }
        let id = req.body.Id;
        let title = req.body.Title;
        let note = req.body.Note;
        let date = req.body.Date;
        data.res = await vaccine.createNote(title, note, date, id);

        res.render("vaccine/write", data);
    }
});

//Add medication
router.get("/vaccine/add/:id", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Add",
            controll: req.session.user[0].role

        };
        let id = req.params.id;

        data.res = await vaccine.patientInfo(id);
        res.render("vaccine/add", data);
    }
});
//Post medication
router.post("/vaccine/add", urlencodedParser, async (req, res) => {

    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Add",
            controll: req.session.user[0].role

        }
        let id = req.body.Id;
        let medication = req.body.Medication;
        let dose = req.body.Dose;
        let start = req.body.Start;
        let end = req.body.End;

        data.res = await vaccine.addMedication(id, medication, dose, start, end);
        res.render("vaccine/add", data);
    }
});

// Get medication for patient
router.get("/vaccine/medication/:id", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Welcome",
            controll: req.session.user[0].role

        };
        let id = req.params.id;
        data.res = await vaccine.patientInfoMedication(id);
        res.render("vaccine/medication", data);
    }
});

//Get contact information
router.get("/vaccine/contact/:id", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "contact",
            controll: req.session.user[0].role

        };
        let id = req.params.id;
        data.res = await vaccine.patientContact(id);
        res.render("vaccine/contact", data);
    }
});

//Vaccination
router.get("/vaccine/vaccination", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Welcome",
            controll: req.session.user[0].role

        };
        data.res = await vaccine.showPatient();
        res.render("vaccine/vaccination", data);
    }
});

//Vaccination Post for searching patient
router.post("/vaccine/vaccination/", urlencodedParser, async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "vaccination",
            controll: req.session.user[0].role

        };
        if(req.body.search == ""){
            data.res = await vaccine.showPatient();
            res.render("vaccine/vaccination", data);
    
        } else {
            data.res = await vaccine.searchPatient(req.body.search);
            res.render("vaccine/vaccination", data);

        }
    }
});

//Get vaccination progress
router.get("/vaccine/vaccine/:id", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Vaccine",
            controll: req.session.user[0].role

        };
        let id = req.params.id;
        data.res = await vaccine.pateintInfoVaccine(id);
        res.render("vaccine/vaccine", data);
    }
});

//Get vaccination progress
router.get("/vaccine/newvaccine/:id", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Vaccine",
            controll: req.session.user[0].role

        };
        let id = req.params.id;
        data.res = await vaccine.pateintInfoVaccine(id);
        res.render("vaccine/newvaccine", data);
    }
});

//Post the new vaccine
router.post("/vaccine/newvaccine/:id", urlencodedParser, async (req, res) => {

    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Add vaccine",
            controll: req.session.user[0].role

        }
        let id = req.body.Id;
        let vaccineName = req.body.Vaccine;
        let dose = req.body.Dose;
        let arm = req.body.Arm;
        let date = req.body.Date;
        
        data.res = await vaccine.patientVaccine(id, vaccineName, dose, arm, date);

   
        res.render("vaccine/newvaccine", data);
    }
});
//Booking
router.get("/vaccine/booking", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "booking",
            controll: req.session.user[0].role

        };
        
        res.render("vaccine/booking", data);
    }
});

//Booking
router.post("/vaccine/booking", urlencodedParser, async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Schedule",
            controll: req.session.user[0].role

        };
        
        let date = req.body.date;
        data.res = await vaccine.getBooking(date);
        res.render("vaccine/schedule", data);
    }
});
//Post for filtering the schedule
router.post("/vaccine/schedule/", urlencodedParser, async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: "Schedule",
            controll: req.session.user[0].role

        };
        let date = req.body.date;
        data.res = await vaccine.getBooking(date);
        res.render("vaccine/schedule", data);
    }
});
//Settings for changing password
router.get("/vaccine/settings", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    }
    else if(req.session.user[0].role == "user") {
        res.redirect("../index");
    } 
     else {
        let data = {
            title: "Settings",
            controll: req.session.user[0].role

        };
        
        data.res = await vaccine.getUsers();
        res.render("vaccine/settings", data);
    }
});

//User update password
router.get("/vaccine/password/:id/", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let id = req.params.id;
        let data = {
            title: `Update pass`,
            controll: req.session.user[0].role

        };

        data.res = await vaccine.getPass(id);
        res.render("vaccine/password", data);

    }
});

//User update password
router.post("/vaccine/password/:id/", urlencodedParser, async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let id = req.params.id;
        let pass = req.body.passwords;
        let data = {
            title: `Update pass`,
            controll: req.session.user[0].role

        };

        data.res = await vaccine.updatePass(id, pass);
        res.render("vaccine/settings", data);

    }
});
//get the new account 
router.get("/vaccine/newaccount/", async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let data = {
            title: `Create account`,
            controll: req.session.user[0].role

        };
        res.render("vaccine/newaccount", data);

    }
});

//User update password
router.post("/vaccine/newaccount/", urlencodedParser, async (req, res) => {
    if(!req.session.user) {
        res.redirect("../vaccine/login");
    } else {
        let user = req.body.username;
        let pass = req.body.password;
        let role = req.body.role;

        let data = {
            title: `Patient Journal`,
            controll: req.session.user[0].role

        };

        data.res = await vaccine.newAccount(user, pass, role);
        res.render("vaccine/newaccount", data);

    }
});
module.exports = router;