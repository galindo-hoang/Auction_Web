import auth from "../mdw/auth.mdw.js";
import Users from "../models/user.js";
import bcrypt from "bcryptjs";
import express from "express";
import viewByProduct from '../models/product.js';
import viewByCategories from '../models/category.js';
import viewByCategoriesDetail from '../models/categories_detail.js'
import products_history from "../models/products_history.js";

const router = express.Router();

router.get("/admin/editCat",auth.beforeLogin, function (req, res){
    res.render("admin/adminViewCat", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/admin/editCat/edit/:id",auth.beforeLogin, async function (req, res){
    const category = await viewByCategories.findByCatID(req.params.id);
    res.render("admin/editCat", {
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
    res.render("admin/addCat");
});

router.post("/admin/editCat/add", auth.beforeLogin, function (req, res){
    viewByCategories.add(req.body);
    res.render("admin/addCat", {
        mess: 'Thêm thành công!'
    });
});

router.get("/admin/editCatDe",auth.beforeLogin, function (req, res){
    res.render("admin/adminViewCatDe", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0
    });
});

router.get("/admin/editCatDe/edit/:id",auth.beforeLogin, async function (req, res){
    const categories_detail = await viewByCategoriesDetail.findByCatDeID(req.params.id);
    res.render("admin/editCatDe", {
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
    res.render("admin/addCatDe");
});

router.post("/admin/editCatDe/add", auth.beforeLogin, function (req, res){
    viewByCategoriesDetail.add(req.body);
    res.render("admin/addCatDe", {
        mess: 'Thêm thành công!'
    });
});

router.get("/admin/editPro",auth.beforeLogin, async function (req, res){
    const product = await viewByProduct.findAll();
    res.render("admin/adminViewPro", {
        user: req.session.account,
        isAdmin: req.session.account.UserRole === 0,
        product
    });
});

router.post("/admin/editPro",auth.beforeLogin, async function (req, res){
    await viewByProduct.del(req.body.ProID);
    res.redirect("/admin/editPro");
});

export default router;