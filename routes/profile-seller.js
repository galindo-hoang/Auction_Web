import express from "express";
import Product from "../models/product.js";
import moment from "moment";
import multer from "multer";
import fs from "fs";
import categories_detail from "../models/categories_detail.js";
import auth from "../mdw/auth.mdw.js";
import win_list from "../models/win_list.js";
import rating_list from "../models/rating_list.js";
import User from "../models/user.js";






const router = express.Router();

router.get('/seller/bidding',auth.beforeLogin,auth.isSeller,async (req, res) => {
    const currentPage = req.query.page || 1;
    const nextPage = (+currentPage)+1;
    const check = await Product.countFindBySeller(req.session.account.UserID);
    const haveNextPage = check.total > (currentPage*5)
    const bidding = await Product.findBySeller(req.session.account.UserID,currentPage * 4);
    // const bidding = [];
    // for (let i = 0; i < products.length;++i){
    //     if(moment(products[i].EndDate) >= moment()) bidding.push(products[i]);
    // }
    res.render('seller/bidding',{
        bidding,
        nextPage,haveNextPage,
        bid:true,
        sellerToBidder: +req.session.account.UserRole === 3
    });
})

router.get("/bidding/loadMore",auth.beforeLogin,auth.isSeller,async (req,res)=>{
    // res.redirect("/seller/bidding?page="+ req.body.page);
    const products = await Product.findByBidding(req.session.account.UserID,4, req.query.nextPage);
    // console.log(products);
    res.json(products);
})

router.get('/seller/add',auth.beforeLogin,auth.isSeller,async (req, res) => {
    const cateDetail = await categories_detail.findAll();
    res.render('seller/add-product', {cateDetail});
})

router.post('/seller/add', (req, res) => {
    const path = './public/imgs/products/' + Math.random();
    const storage = multer.diskStorage({
        destination: function (req, file, cb) {
            if (!fs.existsSync(path)) fs.mkdirSync(path);
            if (!fs.existsSync(path + '/detail')) fs.mkdirSync(path + '/detail');
            if (file.fieldname === "accountImg" || file.fieldname === "thumbImg") cb(null, path);
            else cb(null, path + '/detail');
        },
        filename: function (req, file, cb) {
            if (file.fieldname === 'accountImg') cb(null, 'account.jpg');
            else if (file.fieldname === 'thumbImg') cb(null, 'thumb.jpg');
            else cb(null, file.originalname + '.jpg');
        }
    })


    const upload = multer({storage}).fields([{name: 'accountImg',maxCount:1}, {name: 'thumbImg',maxCount:1}, {name: 'detailImg',maxCount:3}]);
    upload(req, res, async (err) => {
        const object = {};
        const array = moment().format().split("T");
        const hour = array[1].split("+");
        object.ProName = req.body.ProName;
        object.TinyDes = req.body.TinyDes;
        object.FullDes = req.body.FullDes;
        object.StepPrice = req.body.StepPrice;
        object.CurPrice = req.body.CurPrice;
        object.StartPrice = req.body.CurPrice;
        object.BuyNowPrice = req.body.BuyNowPrice;
        object.CatDeID = req.body.CatDeID;
        object.StartDate = array[0] + " " + hour[0];
        object.EndDate = req.body.EndDate;
        object.SellerID = req.session.account.UserID;
        object.Status = 1;
        object.Mail = 0;
        object.AutoExtend = parseInt(req.body.AutoExtend);
        const ID = await Product.addProducts(object);
        fs.rename(path, './public/imgs/products/'+ID[0], async function (err) {
            if (err) {
                console.log(err)
            } else {
                const cateDetail = await categories_detail.findAll();
                res.render('seller/add-product', {cateDetail,mess:"Thêm sản phẩm thành công"});
            }
        })
    });

});

router.get("/seller/end",auth.beforeLogin,auth.isSeller,async (req,res)=>{
    const products = await Product.findEndBidding(req.session.account.UserID);
    for(let i=0;i<products.length;++i){
        products[i].noWin = (products[i].CurPrice === products[i].StartPrice);
        if(!products[i].noWin){
            products[i].bidder = await win_list.findByProID(products[i].ProID);
            products[i].rating = await rating_list.findByProIDUserRateID(products[i].ProID,req.session.account.UserID);
        }
        else products[i].bidder = undefined;
    }
    res.render("seller/endBidding",{products,end:true});

});

router.get("/end/loadMore",auth.beforeLogin,auth.isSeller,async (req,res)=>{
    const products = await Product.findByEnd(req.session.account.UserID,4, req.query.nextPage);
    for(let i=0;i<products.length;++i){
        products[i].noWin = (products[i].CurPrice === products[i].StartPrice);
        if(!products[i].noWin){
            products[i].bidder = await win_list.findByProID(products[i].ProID);
            products[i].rating = await rating_list.findByProIDUserRateID(products[i].ProID,req.session.account.UserID);
        }
        else products[i].bidder = undefined;
    }
    res.json(products);
})

router.get("/account/ratingUser/:id",auth.beforeLogin,auth.isSeller,async (req,res)=>{
    const data = await User.findByID(req.params.id);
    data.Name = data.UserName;
    data.ProID = req.query.ProID;
    res.render("account/rating",{data})
});

router.post("/account/ratingUser/:id",auth.beforeLogin,auth.isSeller,async (req,res)=>{
    const object = {};
    object.ProID = req.body.ProID;
    object.UserID = req.params.id;
    object.UserRateID = req.session.account.UserID;
    object.Rate = req.body.Rate;
    object.Comment = req.body.Comment;
    rating_list.add(object);
    const rates = await rating_list.findByUserID(object.UserID);
    let like = 0;
    for(let i=0;i<rates.length;++i){
        if(rates[i].Rate === 1) ++like;
    }
    User.updateRating(object.UserID,like/rates.length);
    res.redirect("/seller/end");
})
export default router;