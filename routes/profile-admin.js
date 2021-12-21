import auth from "../mdw/auth.mdw.js";
import users from "../models/user.js";
import express from "express";
import viewByProduct from '../models/product.js';
import viewByCategories from '../models/category.js';
import viewByCategoriesDetail from '../models/categories_detail.js'
import products_history from "../models/products_history.js";

const router = express.Router();

router.get("/admin/editCat",auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        res.render("admin/adminViewCat", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0
        });
    }
});

router.get("/admin/editCat/edit/:id",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const category = await viewByCategories.findByCatID(req.params.id);
        res.render("admin/editCat", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0,
            category: category[0]
        });
    }
});

router.post("/admin/editCat/del", auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const result = await viewByCategories.del(req.body.CatID);
        if (result === null) {
            res.redirect('/admin/editCat/edit/' + req.body.CatID);
        } else
            res.redirect('/admin/editCat');
    }
});

router.post("/admin/editCat/save", auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        viewByCategories.saveEdit(req.body);
        res.redirect('/admin/editCat');
    }
});

router.get("/admin/editCat/add", auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else
        res.render("admin/addCat");
});

router.post("/admin/editCat/add", auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        viewByCategories.add(req.body);
        res.render("admin/addCat", {
            mess: 'Thêm thành công!'
        });
    }
});

router.get("/admin/editCatDe",auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        res.render("admin/adminViewCatDe", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0
        });
    }
});

router.get("/admin/editCatDe/edit/:id",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const categories_detail = await viewByCategoriesDetail.findByCatDeID(req.params.id);
        res.render("admin/editCatDe", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0,
            categories_detail: categories_detail[0]
        });
    }
});

router.post("/admin/editCatDe/del", auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const result = await viewByCategoriesDetail.del(req.body.CatDeID);
        if (result === null) {
            res.redirect('/admin/editCatDe/edit/' + req.body.CatDeID);
        } else
            res.redirect('/admin/editCatDe');
    }
});

router.post("/admin/editCatDe/save", auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        viewByCategoriesDetail.saveEdit(req.body);
        res.redirect('/admin/editCatDe');
    }
});

router.get("/admin/editCatDe/add", auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else
        res.render("admin/addCatDe");
});

router.post("/admin/editCatDe/add", auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        viewByCategoriesDetail.add(req.body);
        res.render("admin/addCatDe", {
            mess: 'Thêm thành công!'
        });
    }
});

router.get("/admin/editPro",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const product = await viewByProduct.findAll();
        res.render("admin/adminViewPro", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0,
            product
        });
    }
});

router.post("/admin/editPro",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        await viewByProduct.del(req.body.ProID);
        res.redirect("/admin/editPro");
    }
});

router.get("/admin/editAcc",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const userList = await users.findAll();
        const upgrade = await users.requireUpdate();
        for(let data of userList)
            data.isSeller = +data.UserRole === 1;
        for(let up of upgrade)
            for(let data of userList)
                if(+data.UserID === +up.UserID)
                    data.isUpgrade = true;
        res.render("admin/adminViewAcc", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0,
            userList,
        });
    }
});

router.get("/admin/editSeller",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const sellerList = await users.findAllSeller();
        res.render("admin/adminViewSeller", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0,
            sellerList,
        });
    }
});

router.get("/admin/editBidder",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        const userList = await users.requireUpdate();
        res.render("admin/adminViewBidder", {
            user: req.session.account,
            isAdmin: req.session.account.UserRole === 0,
            userList,
        });
    }
});

router.post("/admin/editAcc/upgrade",auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        users.changeRole(req.body.UserID, 1);
        res.redirect('/admin/editBidder');
    }
});

router.post("/admin/editAcc/downgrade",auth.beforeLogin, function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        users.changeRole(req.body.UserID, 2);
        res.redirect('/admin/editSeller/');
    }
});

router.post("/admin/editAcc/del",auth.beforeLogin, async function (req, res){
    if(req.session.account.UserRole !== 0)
        res.redirect('/');
    else {
        await users.del(req.body.UserID);
        res.redirect('/admin/editAcc/');
    }
});

export default router;