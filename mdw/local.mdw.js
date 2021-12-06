import cookieParser from "cookie-parser";
import session from "express-session";
import Users from '../models/user.js';
import Category from "../models/category.js";
import CategoriesDetail from '../models/categories_detail.js';


const oneDay = 1000 * 60 * 60 * 24;

export default function (app){

    app.use(cookieParser());
    app.use(session({
        secret: "qwee",
        saveUninitialized:false,
        cookie: { maxAge: oneDay },
        resave: false
    }));

    app.use(async function (req, res, next) {
        if (req.session.isAuth) {
            res.locals.IdAuth = (await Users.findByID(req.session.isAuth)).email;
        }
        next();
    });



    app.use(async function (req, res, next) {
        const Cate = await Category.findAll();
        const data = [];
        for(let i=0;i<Cate.length;++i){
            let model = {};
            model.CatName = Cate[i].CatName;
            model.CDList = await CategoriesDetail.findByCatID(Cate[i].CatID);
            data.push(model);
            model.CatID = Cate[i].CatID;
        }
        res.locals.LclCate = data;
        console.log(res.locals.LclCate);
        next();
    });
}