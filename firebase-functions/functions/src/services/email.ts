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

export async function sendEmail(recipient: String, subject: String, body: any, html: any) {

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
    options.text = body || ""
  } else {
    options.html = html || ""
  }

  return await transporter.sendMail(options);
}

// exports.sendEmail = sendEmail
