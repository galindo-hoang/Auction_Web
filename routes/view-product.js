import express from "express";
import viewByProduct from "../models/product.js";
import banned_list from "../models/banned_list.js";
import favorite_list from "../models/favorite_list.js";
import moment from "moment";
import Users from "../models/user.js";
import auth from "../mdw/auth.mdw.js";
import accepted_list from "../models/accepted_list.js";
import products_history from "../models/products_history.js";
import sendEmail from "../utils/mail.js";
import pending_list from "../models/pending_list.js";

const router = express.Router();



router.get('/detail/:id', async (req,res)=>{
    const proID = req.params.id || 1;

    const product = await viewByProduct.findByID(proID);
    const similarProduct = await viewByProduct.findTop5ByCatDeID(product.CatDeID, proID);
    if(req.session.isLogin){
        let mess = "";
        const banned = ((await banned_list.find(req.session.account.UserID,req.params.id)).length === 1);
        if(+req.session.account[req.params.id] === 1){
            mess = "Chúng tôi đã thêm bạn vào hàng chờ";
            delete req.session.account[req.params.id];
        }else if(+req.session.account[req.params.id] === 0){
            mess = "Bạn đang chờ quyết định của người bán";
            delete req.session.account[req.params.id];
        }
        const favorite = await favorite_list.find(req.session.account.UserID,req.params.id);
        const expire = moment(product.EndDate) < moment() || product.CurPrice === product.BuyNowPrice || banned || !product.Status;
        const seller= product.SellerID === req.session.account.UserID;
        let pending_bidder = [];
        if(seller){
            pending_bidder = await Users.findUserPendingByProID(req.params.id);
        }
        res.render('product/detail', {
            product: product,
            similarProduct: similarProduct,
            favorite, expire,seller,pending_bidder, mess,
            isLogin: req.session.isLogin
        });
    }else{
        res.render('product/detail', {
            product: product,
            similarProduct: similarProduct,
            isLogin: req.session.isLogin
        });
    }
});

router.post('/bid',auth.beforeLogin,async (req, res) => {
    const accepted = await accepted_list.find(req.session.account.UserID,req.query.ProID);
    if(req.session.account.UserRating >= 0.8 || accepted.length !== 0){
        const array = moment().format().split("T");
        const hour = array[1].split("+");


        const object = {};
        object.ProID = req.query.ProID;
        object.Price = req.body.Price;
        object.BidderID = req.session.account.UserID;
        object.BidDate = array[0] + " " + hour[0];
        const preBidder = await Users.findPreBidderByID(object.ProID);
        products_history.add(object);
        viewByProduct.updatePrice(object.Price, object.ProID);
        //
        const product = viewByProduct.findByID(req.query.ProID);
        const PronptPrice = product.CurPrice === product.BuyNowPrice;
        if(PronptPrice) viewByProduct.updateStatus(1, object.ProID)
        const seller = await Users.findByProID(object.ProID);
        if (preBidder.length !== 0 && preBidder[0].UserID !== req.session.account.UserID){
            if(PronptPrice) sendEmail(preBidder[0].UserEmail,"Đấu giá","Món hàng bạn đặt đã được mua ngay bởi người khác<div>"+req.headers.referer+"</div>");
            else sendEmail(preBidder[0].UserEmail,"Đấu giá","Món hàng bạn đặt đã được đặt giá bởi người khác :"+ "<b>"+ req.body.Price +" </b><div>"+req.headers.referer+"</div>");
        }
        if(PronptPrice) sendEmail(seller[0].UserEmail,"Sản phẩm của bạn","Sản phẩm của bạn đã được mua ngay <div>"+req.headers.referer+"</div>");
        else sendEmail(seller[0].UserEmail,"Sản phẩm của bạn","Sản phẩm của bạn đã được đặt với mức giá: <b>"+ req.body.Price +"</b><div>"+req.headers.referer+"</div>");
        sendEmail(req.session.account.UserEmail,"chúc mừng","bạn đã ra giá thành công món hàng<div>"+req.headers.referer+"</div>");


        res.redirect('/detail/' + object.ProID);
    }else{
        const pending = await pending_list.find(req.session.account.UserID,req.query.ProID);
        if(pending.length === 0){
            pending_list.add({UserID:req.session.account.UserID,ProID:req.query.ProID});
            req.session.account[""+req.query.ProID] = 1;
            res.redirect('/detail/' + req.query.ProID);
        }else{
            req.session.account[""+req.query.ProID] = 0;
            res.redirect('/detail/' + req.query.ProID);
        }
    }
});

router.post('/detail/denyPending',async (req, res) => {
    pending_list.remove(req.body.BidderID, req.body.ProID);
    banned_list.add({UserID:req.body.BidderID,ProID:req.body.ProID});
    res.redirect('/detail/'+req.body.ProID);
});

router.post('/detail/acceptPending',async (req, res) => {
    pending_list.remove(req.body.BidderID, req.body.ProID);
    accepted_list.add({UserID:req.body.BidderID,ProID:req.body.ProID});
    const bidder = await Users.findByID(req.body.BidderID);
    sendEmail(bidder.UserEmail,"đấu giá sản phẩm","<div>bạn đã được cấp quyền đấu giá sản phẩm</div>"+req.headers.referer);
    res.redirect('/detail/'+req.body.ProID);
})


router.post('/favorite',auth.beforeLogin, async (req,res)=>{
    const data = await favorite_list.find(req.query.UserID,req.query.ProID);
    if(data.length === 0) {
        favorite_list.add({ProID:req.query.ProID,UserID:req.query.UserID});
    }
    else {
        favorite_list.remove(req.query.UserID,req.query.ProID);
    }
    res.redirect("/detail/"+req.query.ProID);
});

export default router;