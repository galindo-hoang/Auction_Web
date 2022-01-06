import express from 'express';
import local_mdw from "./mdw/local.mdw.js";
import view_mdw from "./mdw/view.mdw.js";
import register_route from "./routes/register.js";
import login_route from "./routes/login.js";
import profile_seller_route from "./routes/profile-seller.js";
import profile_user_route from "./routes/profile-user.js";
import profile_admin_route from "./routes/profile-admin.js";
import viewByCategories from './models/category.js';
import viewByProduct from './models/product.js';
import detail_product from "./routes/detail-product.js";
import products_history from "./models/products_history.js";
import cronJob from "./utils/cron.js";

const app = express();

app.use('/public', express.static('public'));
// to get data from user (app.post)
app.use(express.urlencoded({extended: true}));


cronJob.start();


local_mdw(app);
view_mdw(app);
app.use('/', register_route);
app.use('/', login_route);
app.use('/', profile_user_route);
app.use('/', detail_product);
app.use('/', profile_seller_route);
app.use('/', profile_admin_route);

export const addBidAndUserMaxBid = async function (pro) {
    const raw = await products_history.findBidderAndCount(pro.ProID);
    if (raw.length > 0) {
        pro.bid = raw.length;
        pro.nameMaxBid = "***" + raw[0].UserName.substring(Math.trunc(raw[0].UserName.length * 0.8));
    } else {
        pro.bid = 0;
        pro.nameMaxBid = false;
    }
}

app.get('/', async (req, res) => {
    const data = [];
    data.push({}, {}, {});
    data[0].product = (await viewByProduct.findTop5Price());
    data[1].product = (await viewByProduct.findTop5Exp());
    data[2].product = (await viewByProduct.findTop5Bid());
    data[0].title = 'Top 5 sản phẩm có giá cao nhất';
    data[1].title = 'Top 5 sản phẩm gần kết thúc';
    data[2].title = 'Top 5 sản phẩm có nhiều lượt ra giá nhất';

    for (let i = 0; i < data.length; ++i) {
        for (let pro of data[i].product) {
            pro.exp = pro.remaining < 0;
            addBidAndUserMaxBid(pro).then(() => {
            });
        }
    }
    res.render('home', {data});
});

app.get('/views/byCat/:id', async (req, res) => {
    const CatID = req.params.id || 0;

    const limit = 8;
    const page = req.query.page || 1;
    const sort = req.query.sort || 0;

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
    for (let i = 0; i < products.length; i++) {
        products[i].exp = products[i].diff < 0;

        addBidAndUserMaxBid(products[i]).then(() => {
        });
    }

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
        isOnePage: pageNumbers.length === 1,
        sort
    });
});

app.get('/views/byCatDe/:id', async (req, res) => {
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
    for (let i = 0; i < products.length; i++) {
        products[i].exp = products[i].diff < 0;
        addBidAndUserMaxBid(products[i]).then(() => {
        });
    }
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
        isOnePage: pageNumbers.length === 1,
        sort
    });
});

app.post('/views', async (req, res) => {
    res.redirect('/views/' + req.body.query + "?sort=" + req.body.sort + "&page=" + req.body.page)
})

app.get('/views/:query', async (req, res) => {
    const totalProduct = await viewByProduct.countFTS(req.params.query);
    const limit = 8;
    let totalPage = Math.floor(totalProduct / limit);
    if (totalProduct % limit > 0) ++totalPage;
    const page = req.query.page
    const offset = (req.query.page - 1) * limit;
    const data = await viewByProduct.FTS(req.params.query, limit, offset, req.query.sort);
    for (let pro of data) {
        pro.remaining = await viewByProduct.findRemaining(pro.ProID);
        pro.exp = pro.remaining.diff < 0;

        const raw = await products_history.findBidderAndCount(pro.ProID);
        let data = {}
        if (raw.length > 0) {
            pro.bid = raw.length;
            pro.nameMaxBid = raw[0].UserName;
            data = {'bid': raw.length, 'nameMaxBid': raw[0].UserName};
        } else {
            pro.bid = 0;
            pro.nameMaxBid = false;
        }
    }
    const pageNumbers = [];
    for (let i = 1; i <= totalPage; ++i) {
        pageNumbers.push({
            value: i,
            isCurrent: +page === i
        });
    }
    res.render('product/viewByQuery', {
        products: data, query: req.params.query, pageNumbers, sort: req.query.sort, isEnd: +page === totalPage,
        isStart: +page === 1, nextPage: +page + 1, previousPage: +page - 1, isOnePage: pageNumbers.length === 1
    });
})

app.get('/err', function (req, res) {
    throw new Error('Error!');
});

app.use(function (req, res, next) {
    res.render('404', { layout: false });
});

app.use(function (err, req, res, next) {
    console.error(err.stack);
    // res.status(500).send('Something broke!')
    res.render('500', { layout: false });
});

app.listen(3000, () => {
    console.log(`Website running at http://localhost:${3000}`);
});