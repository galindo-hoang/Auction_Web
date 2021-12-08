import nodemailer from "nodemailer";


const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    service: 'gmail',
    auth:{
        user: 'webclc2@gmail.com',
        pass: 'webktpm2',
    }
});

const sendEmail= function (email,title,content) {
    transporter.sendMail({
        to: email, // list of receivers
        subject: title, // Subject line
        html: "<b>" + content + "</b>", // html body
    }).then(()=>{});
}

export default sendEmail;