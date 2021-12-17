import auth from "../mdw/auth.mdw.js";
import Users from "../models/user.js";
import bcrypt from "bcryptjs";
import express from "express";
import viewByProduct from '../models/product.js';
import viewByCategories from '../models/category.js';
import viewByCategoriesDetail from '../models/categories_detail.js'
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

router.get("/admin/editCat",auth.beforeLogin, function (req, res){
    res.render("account/adminViewCat", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/admin/editCat/edit/:id",auth.beforeLogin, async function (req, res){
    const category = await viewByCategories.findByCatID(req.params.id);
    res.render("account/editCat", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0,
        category: category[0]
    });
});

router.post("/admin/editCat/del", auth.beforeLogin, async function (req, res){
    const result = await viewByCategories.del(req.body.CatID);
    if (result === null) {
        res.redirect('/admin/editCat/edit/' + req.body.CatID);
    }
    else
        res.redirect('/admin/editCat');
});

router.post("/admin/editCat/save", auth.beforeLogin, function (req, res){
    viewByCategories.saveEdit(req.body);
    res.redirect('/admin/editCat');
});

router.get("/admin/editCat/add", auth.beforeLogin, function (req, res){
    res.render("account/addCat");
});

router.post("/admin/editCat/add", auth.beforeLogin, function (req, res){
    viewByCategories.add(req.body);
    res.redirect('/admin/editCat');
});




router.get("/admin/editCatDe",auth.beforeLogin, function (req, res){
    res.render("account/adminViewCatDe", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/admin/editCatDe/edit/:id",auth.beforeLogin, async function (req, res){
    const categories_detail = await viewByCategoriesDetail.findByCatDeID(req.params.id);
    res.render("account/editCatDe", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0,
        categories_detail: categories_detail[0]
    });
});

router.post("/admin/editCatDe/del", auth.beforeLogin, async function (req, res){
    const result = await viewByCategoriesDetail.del(req.body.CatDeID);
    if (result === null) {
        res.redirect('/admin/editCatDe/edit/' + req.body.CatDeID);
    }
    else
        res.redirect('/admin/editCatDe');
});

router.post("/admin/editCatDe/save", auth.beforeLogin, function (req, res){
    viewByCategoriesDetail.saveEdit(req.body);
    res.redirect('/admin/editCatDe');
});

router.get("/admin/editCatDe/add", auth.beforeLogin, function (req, res){
    res.render("account/addCatDe");
});

router.post("/admin/editCatDe/add", auth.beforeLogin, function (req, res){
    viewByCategoriesDetail.add(req.body);
    res.redirect('/admin/editCatDe');
});

export default router;