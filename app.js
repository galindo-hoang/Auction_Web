import express  from 'express';
import Users from './models/user.js';
import bcrypt from 'bcryptjs';
import local_mdw from "./mdw/local.mdw.js";
import view_mdw from "./mdw/view.mdw.js";
import register_route from "./routes/register.js";
import viewByCategories from './models/category.js';
import viewByProduct from './models/product.js';


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
    req.session.retUrl = req.headers.referer;
    res.render('account/login');
});

app.post("/account/login",async (req, res) => {
    const url = req.session.retUrl || '/';
    res.redirect(url);
});

app.get('/account/login/check',async (req, res) => {
    const data = await Users.findByEmail(req.query.email);
    if (data.length === 0) res.json(false);
    else {
        if(bcrypt.compareSync(req.query.password,data[0].UserPassword)){
            req.session.isLogin = true;
            req.session.account = data[0];
            delete req.session.account.UserPassword;
            return res.json(true);
        }
    } return res.json(false);
});

app.post("/account/signout",(req,res)=>{
    req.session.isLogin = false;
    req.session.account = null;
    const url = req.headers.referer || '/';
    res.redirect(url);
});


import auth from "./mdw/auth.mdw.js";

app.get("/account/profile",auth,async (req, res) => {
    const data = await Users.findByID(req.session.isLogin);
    res.render("account/profile", {user: data});
});

app.get("/account/review",auth,(req,res)=>{
    res.render("account/review");
});

app.get("/account/tracking",auth,(req,res)=>{
    res.render("account/tracking");
});

app.get("/account/favorite",auth,(req,res)=>{
    res.render("account/favorite");
});

app.get("/account/purchased",auth,(req,res)=>{
    res.render("account/purchase");
});

app.listen(300,()=>{
    console.log(`Example app listening at http://localhost:${300}`);
});