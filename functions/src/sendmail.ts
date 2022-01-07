exports.handler = function(req, res, cors, nodemailer) {
    if (req.method !== "POST") {
        return res.status(405).send(`${req.method} method not allowed`);
    }
    const transporter = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 465,
        secure: true,
        auth: {
            user: "ronaldohws@gmail.com",
            pass: "lqkmhihwxljwiser"
        }
    });
    cors(req, res, async () => {
        const from = `"${req.body["from_name"]}" <${req.body["from_email"]}>`;
        const to = `"${req.body["to_name"]}" <${req.body["to_email"]}>`;
        const subject = `Contato site ${req.body["from_name"]}`;
        let content = req.body["content"];
        const textFrom = `${subject}\n\nNome: ${req.body["to_name"]}\nEmail: ${req.body["to_email"]}\nFone: ${req.body["to_phone"]}\n\nMensagem:\n${content}\n\n\nAtt,\n\n${req.body["from_name"]}`;
        const textTo = `Olá ${req.body["to_name"]},\n\nRecebemos sua mensagem, em breve entraremos em contato.\n\n\nAtenciosamente,\n\n${req.body["from_name"]}`;
        content = content.replace(/(?:\r\n|\r|\n)/g, "<br>");
        const htmlFrom = `<h2>${subject}</h2>Nome: <strong>${req.body["to_name"]}</strong><br>Email: <strong>${req.body["to_email"]}</strong><br>Fone: <strong>${req.body["to_phone"]}</strong><br><br>Mensagem:<br><strong>${content}</strong><br><br><br>Att,<br><br>${req.body["from_name"]}`;
        const htmlTo = `Olá <strong>${req.body["to_name"]}</strong>,<br><br>Recebemos sua mensagem, em breve entraremos em contato.<br><br><br>Atenciosamente,<br><br>${req.body["from_name"]}`;
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
        await transporter.sendMail(emailEnterprise, async (error, info) => {
            if (error) {
                console.log(`Erro ao enviar email...\n${error}`);
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
