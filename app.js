import express from 'express';
import local_mdw from "./mdw/local.mdw.js";
import view_mdw from "./mdw/view.mdw.js";
import register_route from "./routes/register.js";
import login_route from "./routes/login.js";
import profile_user_route from "./routes/profile-user.js";
import viewByCategories from './models/category.js';
import viewByProduct from './models/product.js';
import view_product from "./routes/view-product.js";

const app = express();

app.use('/public', express.static('public'));
// to get data from user (app.post)
app.use(express.urlencoded({extended:true}));

local_mdw(app);
view_mdw(app);
app.use('/',register_route);
app.use('/',login_route);
app.use('/',profile_user_route);
app.use('/',view_product);


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
    const sort = req.query.sort || 1;

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

    const products = await viewByCategories.findPageByCatId(CatID, limit, offset, sort);
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
    const sort = req.query.sort || 1;

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
    const products = await viewByProduct.findPageByCatDeId(CatDeID, limit, offset, sort);
    const name = await viewByProduct.findCatDeName(CatDeID);

    res.render('product/viewByCatDetail', {
        CatDeID: CatDeID,
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
        pro.remaining = await viewByProduct.findRemaining(pro.ProID);
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

app.use(function (req, res, next) {
    res.render('404', { layout: false });
});

app.use(function (err, req, res, next) {
    console.error(err.stack)
    // res.status(500).send('Something broke!')
    res.render('500', { layout: false });
});

app.listen(300,()=>{
    console.log(`Example app listening at http://localhost:${300}`);
});