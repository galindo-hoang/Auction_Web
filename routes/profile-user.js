import auth from "../mdw/auth.mdw.js";
import Users from "../models/user.js";
import bcrypt from "bcryptjs";
import express from "express";
import viewByProduct from '../models/product.js';
import products_history from "../models/products_history.js";


const router = express.Router();

router.get("/account/profile",auth.beforeLogin,async (req, res) => {
    res.render("account/profile", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.post("/account/profile",auth.beforeLogin,async (req, res) => {
    req.session.account.UserName = req.body.name;
    req.session.account.DOB = req.body.birthday;
    const account = await Users.findByEmail(req.session.account.UserEmail);
    if(req.body.CurPassword === "" && req.body.NewPassword === "" && req.body.ConPassword === ""){
        Users.updateUserWithoutPass(req.session.account.DOB,req.session.account.UserName,req.session.account.UserEmail);
        res.render("account/profile",{user: req.session.account});
    }else if(!bcrypt.compareSync(req.body.CurPassword,account[0].UserPassword)){
        res.render("account/profile",{user: req.session.account,error: "Mật khẩu hiện tại không đúng"});
    }else if(req.body.NewPassword !==  req.body.ConPassword){
        res.render("account/profile",{user: req.session.account,error: "Mật khẩu hiện không trùng khớp"});
    }else{
        Users.updateUser(req.body.NewPassword,req.session.account.DOB,req.session.account.UserName,req.session.account.UserEmail);
        res.render("account/profile",{user: req.session.account});
    }
});

router.get("/account/review",auth.beforeLogin,(req,res)=>{
    res.render("account/review", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/account/tracking",auth.beforeLogin,async (req, res) => {
    const products = await products_history.findByTracking(req.session.account.UserID);
    res.render("account/tracking", {
        products,
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/account/favorite",auth.beforeLogin,async (req, res) => {
    const products = await viewByProduct.findByFavorite(req.session.account.UserID);
    res.render("account/favorite", {
        products,
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/account/purchased",auth.beforeLogin,(req, res) => {
    res.render("account/purchase", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

export default router;