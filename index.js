"use strict";
const express = require("express");
const port = 1337;
const indexRoutes = require("./route/vaccine.js");
const path = require("path");
const app = express();

app.set("view engine", "ejs");
app.use(express.static(path.join(__dirname, "public")));
app.use((req, res, next) =>{
    console.info(`Got a request on: ${req.path} (${req.method})`);
    next();
});
app.use("/", indexRoutes);


app.listen(port, () =>{});

