"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendEmail = void 0;
const nodemailer = require('nodemailer');
let transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true,
    auth: {
        user: 'soveti.informacii@gmail.com',
        pass: process.env.EMAIL_APP_KEY
    }
});
async function sendEmail(recipient, subject, body, html) {
    const options = {
        from: {
            name: "Advices",
            address: "soveti.informacii@google.com",
        },
        to: recipient,
        subject: subject,
        html: String,
        text: String,
    };
    if ((html || "").toString().length === 0) {
        options.text = body || "";
    }
    else {
        options.html = html || "";
    }
    return await transporter.sendMail(options);
}
exports.sendEmail = sendEmail;
// exports.sendEmail = sendEmail
//# sourceMappingURL=email.js.map