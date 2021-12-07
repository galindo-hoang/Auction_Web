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
    const data = [];
    data.push({},{},{});
    data[0].product = (await viewByProduct.findTop5Price());
    data[1].product = (await viewByProduct.findTop5Exp());
    data[0].title = 'Top 5 sản phẩm có giá cao nhất';
    data[1].title = 'Top 5 sản phẩm gần kết thúc';
    data[2].title = 'Top 5 sản phẩm có nhiều lượt ra giá nhất';
    res.render('home',{data});
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
            isCurrent: +page === i,
        });
    }

    const products = await viewByCategories.findPageByCatId(CatID, limit, offset);
    const name = await viewByCategories.findCatName(CatID);

    res.render('product/viewByCat', {
        CatID: CatID,
        products: products,
        empty: products.length === 0,
        pageNumbers,
        CatName: name[0].CatName,
        isEnd: +page === nPages,
        isStart: +page === 1,
        nextPage: +page + 1,
        previousPage: +page - 1,
        isOnePage: pageNumbers.length === 1
    });
});

app.get('/views/byCatDe/:id',async (req,res)=>{
    const CatDeID = req.params.id || 0;

    const limit = 8;
    const page = req.query.page || 1;
    const offset = (page - 1) * limit;

    const total = await viewByProduct.countByProId(CatDeID);

    let nPages = Math.floor(total / limit);
    if (total % limit > 0) nPages++;

    const pageNumbers = [];
    for (let i = 1; i <= nPages; i++) {
        pageNumbers.push({
            value: i,
            isCurrent: +page === i
        });
    }
    const products = await viewByProduct.findPageByCatDeId(CatDeID, limit, offset);
    const name = await viewByProduct.findCatDeName(CatDeID);

    res.render('product/viewByCatDetail', {
        products: products,
        empty: products.length === 0,
        pageNumbers,
        CatDeName: name[0].CatDeName,
        isEnd: +page === nPages,
        isStart: +page === 1,
        nextPage: +page + 1,
        previousPage: +page - 1,
        isOnePage: pageNumbers.length === 1
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
    res.render("account/profile", {user: req.session.account});
});

app.post("/account/profile",auth,async (req, res) => {
    req.session.account.UserName = req.body.name;
    req.session.account.DOB = req.body.birthday;
    const account = Users.findByEmail(req.session.account.UserEmail);
    if(req.body.CurPassword === "" && req.body.NewPassword === "" && req.body.ConPassword === ""){
        Users.updateUserWithoutPass(req.session.account.DOB,req.session.account.UserName,req.session.account.UserEmail);
        res.render("account/profile",{user: req.session.account});
    }else if(bcrypt.compareSync(req.body.CurPassword,account[0].UserPassword)){
        res.render("account/profile",{error: "Mật khẩu hiện tại không đúng"});
    }else if(req.body.NewPassword !==  req.body.ConPassword){
        res.render("account/profile",{error: "Mật khẩu hiện không trùng khớp"});
    }else{
        Users.updateUser(req.body.NewPassword,req.session.account.DOB,req.session.account.UserName,req.session.account.UserEmail);
        res.render("account/profile",{user: req.session.account});
    }
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

app.post('/views',async (req, res) => {
    res.redirect('/views/'+req.body.query+"?sort="+req.body.sort+"&page="+req.body.page)
})

app.get('/views/:query',async (req, res) => {
    const totalProduct = await viewByProduct.countFTS(req.params.query);
    const limit = 8;
    let totalPage = Math.floor(totalProduct / limit);
    if (totalProduct % limit > 0) ++totalPage;
    const page = req.query.page
    const offset = (req.query.page - 1) * limit;
    const data = await viewByProduct.FTS(req.params.query, limit, offset,req.query.sort);
    for(let pro of data){
        const remaining = await viewByProduct.findRemaining(pro.ProID);
        pro.remaining = remaining;
    }
    const pageNumbers = [];
    for (let i = 1; i <= totalPage; ++i) {
        pageNumbers.push({
            value: i,
            isCurrent: +page === i
        });
    }
    res.render('product/viewByQuery',{products:data,query:req.params.query,pageNumbers,sort:req.query.sort,isEnd: +page === totalPage,
        isStart: +page === 1,nextPage: +page + 1,previousPage: +page - 1,isOnePage: pageNumbers.length === 1
    });
})

app.listen(300,()=>{
    console.log(`Example app listening at http://localhost:${300}`);
    // console.log("TEST");
});