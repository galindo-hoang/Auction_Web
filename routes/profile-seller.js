import express from "express";
import Product from "../models/product.js";
import moment from "moment";
import multer from "multer";
import fs from "fs";
import categories_detail from "../models/categories_detail.js";
import auth from "../mdw/auth.mdw.js";






const router = express.Router();

router.get('/seller/bidding',auth.beforeLogin,auth.isSeller,async (req, res) => {
    const products = await Product.findBySeller(req.session.account.UserID);
    const bidding = [];
    for (let i = 0; i < products.length;++i){
        if(moment(products[i].EndDate) >= moment()) bidding.push(products[i]);
    }
    res.render('seller/bidding',{bidding,seller:true});
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

})

export default router;