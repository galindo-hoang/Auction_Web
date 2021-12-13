import Users from "../models/user.js";
import sendEmail from "../utils/mail.js";
import bcrypt from "bcryptjs";
import express from "express";
import auth from "../mdw/auth.mdw.js";




const router = express.Router();
const check = {}


router.get("/account/login",auth.afterLogin,(req,res)=>{
    req.session.retUrl = req.headers.referer;
    res.render('account/login');
});

router.post("/account/login",async (req, res) => {
    const url = req.session.retUrl || '/';
    res.redirect(url);
});

router.get('/account/login/check',auth.afterLogin,async (req, res) => {
    const data = await Users.findByEmail(req.query.email);
    if (data.length === 0) res.json(false);
    else {
        if(bcrypt.compareSync(req.query.password,data[0].UserPassword)){
            req.session.isLogin = true;
            req.session.account = data[0];
            delete req.session.account.UserPassword;
            return res.json(true);
        }else return res.json(false);
    }
});




router.get("/account/FP",auth.afterLogin,(req,res)=>{
    res.render("account/forget-password");
});

router.post("/account/FP",async (req, res) => {
    const account = await Users.findByEmail(req.body.email);
    if(account.length === 0){
        res.render("account/forget-password",{error: "Tài khoản không tồn tại"});
    }else{
        check.email = req.body.email;
        let otp = Math.random();
        otp = otp * 100000;
        check.otp = parseInt(otp);

        sendEmail(req.body.email,"OTP",check.otp+"");
        res.redirect("/account/FP/verify");
    }
})

router.get("/account/FP/verify",auth.afterLogin,(req,res)=>{
    res.render("account/verify");
})

router.post("/account/FP/verify",(req,res)=>{
    if(+req.body.otp === check.otp) res.redirect("/account/FP/verify/changePassword");
    else{
        res.render("account/verify",{email:check.email,error: "OTP không hợp lệ"});
    }
})
router.get("/account/FP/verify/changePassword",auth.afterLogin,(req,res)=>{
    res.render("account/change-password");
})
router.post("/account/FP/verify/changePassword",(req,res)=>{
    if(req.body.Conpass === req.body.pass){
        const salt = bcrypt.genSaltSync(10);
        const password = bcrypt.hashSync(req.body.pass, salt);
        Users.changePassword(check.email,password);
        res.redirect("/account/login");
    }else{
        res.render("account/change-password",{error: "Mật khẩu không trùng khớp"});
    }
})



router.post("/account/signout",(req,res)=>{
    req.session.isLogin = false;
    req.session.account = null;
    const url = req.headers.referer || '/';
    res.redirect(url);
});

export default router;