"use strict";
const sendMail = require("./sendmail");
const counterView = require("./counterview");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();

const nodemailer = require("nodemailer");
const cors = require("cors")({
    origin: true
});

exports.sendMail = functions.https.onRequest((req, res) => {
    sendMail.handler(req, res, cors, nodemailer);
});

exports.counterView = functions.https.onRequest((req, res) => {
    counterView.handler(req, res, firestore);
});
