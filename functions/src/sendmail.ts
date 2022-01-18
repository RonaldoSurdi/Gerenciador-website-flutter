exports.handler = async function(req, res, firestore, cors, nodemailer) {
    res.set("Access-Control-Allow-Origin", "*");
    if (req.method !== "POST") {
        return res.status(405).send(`${req.method} method not allowed`);
    }
    cors(req, res, async () => {
        const refSecure = await firestore.collection("settings").doc("secure").get();
        const settingsSecure = await refSecure.data();
        const ipAddress = req.headers["x-forwarded-for"] || req.connection.remoteAddress;
        const transporter = await nodemailer.createTransport({
            host: settingsSecure.smtphost,
            port: settingsSecure.smtpport,
            secure: settingsSecure.smtpsecure,
            auth: {
                user: settingsSecure.smtpuser,
                pass: settingsSecure.smtppass
            }
        });
        const refData = await firestore.collection("settings").doc("data").get();
        const settingsData = await refData.data();
        const fromName = settingsData.name;
        const fromEmail = settingsData.email;
        const toName = req.body["to_name"];
        const toEmail = req.body["to_email"];
        const message = req.body["content"];
        let toPhone = req.body["to_phone"];
        let cityUf = req.body["city_uf"];
        let content = req.body["content"];
        if (toName == null || toName == undefined || toName == "") {
            return res.status(422).send("Digite o seu nome completo");
        }
        if (toEmail == null || toEmail == undefined || toEmail == "") {
            return res.status(422).send("Digite o seu email");
        }
        if (cityUf == null || cityUf == undefined || cityUf == "") {
            return res.status(422).send("Digite o seu local (Cidade/UF)");
        }
        if (content == null || content == undefined || content == "") {
            return res.status(422).send("Digite a mensagem");
        }
        if (toPhone == null || toPhone == undefined) {
            toPhone = "";
        }
        if (cityUf == null || cityUf == undefined) {
            cityUf = "";
        }
        if (content == null || content == undefined) {
            content = "";
        }
        const from = `"${fromName}" <${fromEmail}>`;
        const to = `"${toName}" <${toEmail}>`;
        const subject = `Contato site ${fromName}`;
        const textFrom = `${subject}\n\nNome: ${toName}\nEmail: ${toEmail}\nFone: ${toPhone}\nLocal: ${cityUf}\nIp address: ${ipAddress}\n\nMensagem:\n${content}\n\n\nAtt,\n\n${fromName}`;
        const textTo = `Olá ${toName},\n\nRecebemos sua mensagem, em breve entraremos em contato.\n\n\nAtenciosamente,\n\n${fromName}`;
        content = content.replace(/(?:\r\n|\r|\n)/g, "<br>");
        const htmlFrom = `<h2>${subject}</h2>Nome: <strong>${toName}</strong><br>Email: <strong>${toEmail}</strong><br>Fone: <strong>${toPhone}</strong><br>Local: ${cityUf}<br>Ip address: <strong>${ipAddress}</strong><br><br>Mensagem:<br><strong>${content}</strong><br><br><br>Att,<br><br>${fromName}`;
        const htmlTo = `Olá <strong>${toName}</strong>,<br><br>Recebemos sua mensagem, em breve entraremos em contato.<br><br><br>Atenciosamente,<br><br>${fromName}`;
        const emailEnterprise = {
            from: to,
            to: from,
            subject: subject,
            text: textFrom,
            html: htmlFrom
        };
        const emailClient = {
            from: from,
            to: to,
            subject: subject,
            text: textTo,
            html: htmlTo
        };
        const timestamp = new Date(Date.now());
        const contactId = Date.now();
        const docModel = {
            "id": contactId,
            "name": toName,
            "email": toEmail,
            "phone": toPhone,
            "cityuf": cityUf,
            "message": message,
            "ip": ipAddress,
            "send": timestamp,
            "read": null,
            "view": false
        };
        await firestore.collection("contacts").doc(`${contactId}`).set(docModel);
        await transporter.sendMail(emailEnterprise, async (error, info) => {
            if (error) {
                console.log(`Erro ao enviar email...\n${error}\n${info}`);
                return res.status(400).send("Erro ao enviar email, tente novamente...");
            }
            await transporter.sendMail(emailClient, (error, info) => {
                if (error) {
                    console.log(`Erro ao enviar email...\n${error}`);
                    return res.status(400).send("Erro ao enviar email, tente novamente...");
                }
                console.log(`Email enviado...\n${info.messageId}\n${info.response}`);
                return res.status(200).send("Mensagem enviada com sucesso!");
            });
        });
    });
};
