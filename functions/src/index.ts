'use strict';
const functions  = require('firebase-functions');
const nodemailer = require('nodemailer');
const cors = require('cors')({origin: true});

let url = "smtps://ronaldohws%40gmail.com:"+encodeURIComponent('lqkmhihwxljwiser') + "@smtp.gmail.com:465";
let transporter = nodemailer.createTransport(url);

exports.enviarEmail = functions.https.onRequest((req: any, res: any, conf: any) => {
  cors(req, res, () => {
    let remetente = `"${conf['from_name']}" <${conf['from_email']}>`;

    let assunto = req.body['assunto'];
    let destinatarios = req.body['destinatarios']; // lista de e-mails destinatarios separados por ,
    let corpo = req.body['corpo'];
    let corpoHtml = req.body['corpoHtml'];

    let email = {
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
        console.log('Mensagem %s enviada: %s', info.messageId, info.response);
    });
  });
});