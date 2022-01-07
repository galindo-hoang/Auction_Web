import session from "express-session";
import Category from "../models/category.js";
import CategoriesDetail from '../models/categories_detail.js';
import fnMySQLStore from 'express-mysql-session';
import Users from '../models/user.js'
import {ConnectInfor} from "../utils/db.js";

export default function (app) {

    const MySQLStore = fnMySQLStore(session);
    const SessionStore = new MySQLStore(ConnectInfor);
    app.set('trust proxy', 1) // trust first proxy
    app.use(session({
        secret: "secret",
        saveUninitialized: true,
        store: SessionStore,
        resave: false
    }));

    app.use(async function (req, res, next) {
        if (typeof (req.session.isLogin) === 'undefined') {
            req.session.isLogin = false;
        }
        if (req.session.account) {
            const model = await Users.findByID(req.session.account.UserID);
            req.session.account.UserRating = model.UserRating;
            req.session.account.UserRole = model.UserRole;
            delete req.session.account.UserPassword;
            res.locals.seller = (+req.session.account.UserRole === 1 || +req.session.account.UserRole === 3);
        }
        res.locals.account = req.session.account;
        res.locals.isLogin = req.session.isLogin;
        next();
    });

    app.use(async function (req, res, next) {
        const Cate = await Category.findAll();
        const data = [];
        for (let i = 0; i < Cate.length; ++i) {
            let model = {};
            model.CatName = Cate[i].CatName;
            model.CDList = await CategoriesDetail.findByCatID(Cate[i].CatID);
            data.push(model);
            model.CatID = Cate[i].CatID;
        }
        res.locals.LclCate = data;
        next();
    });
}