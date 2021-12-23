"use strict";
const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
const cors = require("cors")({
  origin: true
});
const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: "ronaldohws@gmail.com",
    pass: "lqkmhihwxljwiser"
  }
});
// const functions = require("@google-cloud/functions-framework");
// const url = "smtps://ronaldohws%40gmail.com:" + encodeURIComponent("lqkmhihwxljwiser") + "@smtp.gmail.com:465";
// const transporter = nodemailer.createTransport(url);
exports.enviarEmail = functions.https.onRequest(
    (req: any, res: any, conf: any) => {
      cors(req, res, () => {
        const remetente = `"${conf["from_name"]}" <${conf["from_email"]}>`;
        const assunto = req.body["assunto"];
        const destinatarios = req.body["destinatarios"];
        const corpo = req.body["corpo"];
        const corpoHtml = req.body["corpoHtml"];
        const email = {
          from: remetente,
          to: destinatarios,
          subject: assunto,
          text: corpo,
          html: corpoHtml
        };
        transporter.sendMail(email, (error: any, info: any) => {
          if (error) {
            return console.log(error);
          }
          console.log("Mensagem %s enviada: %s", info.messageId, info.response);
        });
      });
    }
);
