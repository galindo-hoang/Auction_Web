import fetch from "node-fetch";
import express from "express";
import bcrypt from 'bcryptjs';
import Users from '../models/user.js';
import auth from "../mdw/auth.mdw.js";

import sendEmail from "../utils/mail.js";


const router = express.Router();

let object = {
    UserRole: 2,
    UserRating: 0,
    DOB: null
}
const check = {}

router.get("/account/register", auth.afterLogin,(req,res)=>{
    res.render('account/register');
})

router.post("/account/register", async (req, res) => {
    var salt = bcrypt.genSaltSync(10);
    const password = bcrypt.hashSync(req.body.password, salt);
    object.UserEmail = req.body.email;
    object.UserPassword = password;
    object.UserName = req.body.name;

    var otp = Math.random();
    otp = otp * 100000;
    check.otp = parseInt(otp);

    sendEmail(req.body.email,"OTP",check.otp);

    res.redirect('/account/register/check/verify');
});

router.get("/account/register/check",auth.afterLogin,async (req, res) => {
    const captcha = await fetch(`https://www.google.com/recaptcha/api/siteverify?secret=6Le6CncdAAAAAOzSwB7zdJszhDbO9SjFxpQ11Fnf&response=${req.query.recaptcha}`,{
        method: "POST"
    }).then(_res =>_res.json());
    if(captcha.success === true){
        const data = await Users.findByEmail(req.query.email);
        if(data.length === 0) res.json(true);
        else res.json(false);
    }else res.json(1)
});

router.get("/account/register/check/verify",auth.afterLogin, (req, res) => {
    res.render("account/verify", {email: object.UserEmail});
})

router.post("/account/register/check/verify",(req,res)=>{
    if((check.otp === +req.body.otp)){
        Users.addUser(object);
        object = {}
        res.redirect('/account/login');
    }else{
        res.render("account/verify", {email: object.UserEmail,error: "OTP không hợp lệ"});
    }
})




export default router;