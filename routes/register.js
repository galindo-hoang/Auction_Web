import nodemailer from "nodemailer";
import fetch from "node-fetch";
import express from "express";
import bcrypt from 'bcryptjs';
import Users from '../models/user.js';

const router = express.Router();

let object = {
    admin: false,
    seller: false
}

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
const check = {}

router.get("/account/register", (req,res)=>{
    res.render('account/register');
})

router.post("/account/register", async (req, res) => {
    var salt = bcrypt.genSaltSync(10);
    const password = bcrypt.hashSync(req.body.password, salt);
    object.email = req.body.email;
    object.password = password;
    object.name = req.body.name;

    var otp = Math.random();
    otp = otp * 100000;
    check.otp = parseInt(otp);

    let info = await transporter.sendMail({
        to: "hmhuy191101@gmail.com", // list of receivers
        subject: "OTP", // Subject line
        html: "<b>" + check.otp + "</b>", // html body
    });

    res.redirect('/account/register/check/verify');
});

router.get("/account/register/check",async (req, res) => {
    const captcha = await fetch(`https://www.google.com/recaptcha/api/siteverify?secret=6Le6CncdAAAAAOzSwB7zdJszhDbO9SjFxpQ11Fnf&response=${req.query.recaptcha}`,{
        method: "POST"
    }).then(_res =>_res.json());
    if(captcha.success === true){
        const data = await Users.findByEmail(req.query.email);
        if(data.length === 0) res.json(true);
        else res.json(false);
    }else res.json(1)
});

router.get("/account/register/check/verify", (req, res) => {
    res.render("account/verify", {email: object.email});
})


router.get("/account/register/check/verify/submit",(req,res)=>{
    res.json((check.otp+"" === req.query.otp));
})

router.post("/account/register/check/verify",(req,res)=>{
    Users.addUser(object);
    object = {}
    res.redirect('/account/login');
})

export default router;