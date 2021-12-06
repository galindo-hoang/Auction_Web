import express  from 'express';
import Users from './models/user.js';
import bcrypt from 'bcryptjs';
import local_mdw from "./mdw/local.mdw.js";
import view_mdw from "./mdw/view.mdw.js";
import register_route from "./routes/register.js";
import viewByCategories from './models/category.js';
import viewByProduct from './models/product.js';
import asyncErrors from 'express-async-errors';

const app = express();

app.use('/public', express.static('public'));
// to get data from user (app.post)
app.use(express.urlencoded({extended:true}));

local_mdw(app);
view_mdw(app);
app.use('/',register_route);


app.get('/',async (req, res) => {
    const topPrice = await viewByProduct.findTop5Price();
    const topExp = await viewByProduct.findTop5Exp();
    res.render('home',{price:topPrice,expire:topExp});
});

app.get('/views/byCat/:id',async (req,res)=>{
    const CatID = req.params.id || 0;

    const limit = 8;
    const page = req.query.page || 1;
    const offset = (page - 1) * limit;

    const total = await viewByCategories.countByCatId(CatID);

    let nPages = Math.floor(total.ProductCount / limit);
    if (total.ProductCount % limit > 0) nPages++;

    const pageNumbers = [];
    for (let i = 1; i <= nPages; i++) {
        pageNumbers.push({
            value: i,
            isCurrent: +page === i
        });
    }

    const products = await viewByCategories.findPageByCatId(CatID, limit, offset);
    res.render('product/viewByCat', {
        products: products,
        empty: products.length === 0,
        pageNumbers,
        CatName: products[0].CatName
    });
});

app.get('/views/byCatDe/:id',async (req,res)=>{
    const CatID = req.params.id || 0;

    const limit = 8;
    const page = req.query.page || 1;
    const offset = (page - 1) * limit;

    const total = await viewByProduct.countByProId(CatID);

    let nPages = Math.floor(total / limit);
    if (total % limit > 0) nPages++;

    const pageNumbers = [];
    for (let i = 1; i <= nPages; i++) {
        pageNumbers.push({
            value: i,
            isCurrent: +page === i
        });
    }
    const products = await viewByProduct.findPageByProId(CatID, limit, offset);
    const CatDeName = await viewByProduct.findCatDeName(products[0].CatDeID);
    res.render('product/viewByCatDetail', {
        products: products,
        empty: products.length === 0,
        pageNumbers,
        CatDeName: CatDeName[0].CatDeName
    });
});

app.get('/detail',(req,res)=>{
    res.render('product/detail');
});

app.get("/account/login",(req,res)=>{
    res.render('account/login');
});

app.post("/account/login",async (req, res) => {
    req.session.isAuth = (await Users.findByEmail(req.body.email))[0].id;
    res.redirect('/');
});

app.get('/account/login/check',async (req, res) => {
    const data = await Users.findByEmail(req.query.email);
    if (data.length === 0) res.json(false);
    else return res.json(bcrypt.compareSync(req.query.password,data[0].password));
});

app.get("/account/signOut",(req,res)=>{
    req.session.destroy(function (err) {
        res.redirect("/");
    })
});

app.get("/account/profile",async (req, res) => {
    const data = await Users.findByID(req.session.isAuth);
    res.render("account/profile", {user: data});
});

app.get("/account/review",(req,res)=>{
    res.render("account/review");
});

app.get("/account/tracking",(req,res)=>{
    res.render("account/tracking");
});

app.get("/account/favorite",(req,res)=>{
    res.render("account/favorite");
});

app.get("/account/purchased",(req,res)=>{
    res.render("account/purchase");
});

app.listen(300,()=>{
    console.log(`Example app listening at http://localhost:${300}`);
});