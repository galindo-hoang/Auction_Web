import auth from "../mdw/auth.mdw.js";
import Users from "../models/user.js";
import bcrypt from "bcryptjs";
import express from "express";
import viewByProduct from '../models/product.js';
import products_history from "../models/products_history.js";
import win_list from "../models/win_list.js";
import user from "../models/user.js";
import rating_list from "../models/rating_list.js"
import User from "../models/user.js";
import upgradeList from "../models/upgrade_list.js";
import favorite_list from "../models/favorite_list.js";


const router = express.Router();

router.get("/account/profile",auth.beforeLogin,async (req, res) => {
    const upgradeReq = await upgradeList.getUserID(req.session.account.UserID);
    req.session.account.UserRating = (await User.findRatingByUserID(req.session.account.UserID)).UserRating;
    res.render("account/profile", {
        profile: true,
        user: req.session.account,
        isBidder: +req.session.account.UserRole === 2,
        isAdmin: +req.session.account.UserRole === 0,
        isRequested: upgradeReq.length !== 0
    });
});

router.post('/account/profile/upgrade', auth.beforeLogin, async function (req, res){
    upgradeList.insert(req.body);
    const upgradeReq = await upgradeList.getUserID(req.session.account.UserID);
    res.redirect('/account/profile');
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

router.get("/account/review",auth.beforeLogin,async (req, res) => {
    const rates = await rating_list.findByUserRateID(req.session.account.UserID);
    res.render("account/review", {
        review: true,
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0,
        rates
    });
});

router.get("/account/tracking",auth.beforeLogin,async (req, res) => {
    const products = await products_history.findByTracking(req.session.account.UserID);
    res.render("account/tracking", {
        tracking: true,
        products,
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/account/favorite",auth.beforeLogin,async (req, res) => {
    const products = await viewByProduct.findByFavorite(req.session.account.UserID);
    res.render("account/favorite", {
        favorite: true,
        products,
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});


router.post("/account/favorite",auth.beforeLogin,async (req, res) => {
    favorite_list.remove(req.session.account.UserID,req.body.ProID);
    res.redirect("/account/favorite");
});

router.get("/account/win",auth.beforeLogin,async (req, res) => {
    const products = await viewByProduct.findByWinList(req.session.account.UserID);
    for (let i=0;i<products.length;++i){
        const rating = await win_list.findByRating(products[i].ProID,products[i].UserID);
        products[i].rating = rating.length !== 0;
    }
    // const products = await win_list.findByRating()
    res.render("account/win_list", {
        win: true,
        products,
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/account/ratingProduct/:id",auth.beforeLogin,async (req, res) => {
    const data = await viewByProduct.findToRating(req.params.id);
    data.Name = data.ProName;
    res.render("account/rating",{data});
})

router.post("/account/ratingProduct/:id",auth.beforeLogin,async (req, res) => {
    const seller = (await user.findByProID(req.params.id))[0];
    const object = {};
    object.ProID = req.params.id;
    object.UserID = seller.UserID;
    object.UserRateID = req.session.account.UserID;
    object.Rate = req.body.Rate;
    object.Comment = req.body.Comment;
    rating_list.add(object);

    const rates = await rating_list.findByUserID(object.UserID);
    let like = 0;
    for(let i=0;i<rates.length;++i){
        if(rates[i].Rate === 1) ++like;
    }
    User.updateRating(object.UserID,like/rates.length);
    res.redirect("/account/win");
})

export default router;