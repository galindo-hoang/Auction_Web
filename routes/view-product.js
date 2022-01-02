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
import fs from "fs";
import win_list from "../models/win_list.js";

const router = express.Router();



router.get('/detail/:id', async (req,res)=>{
    const proID = req.params.id || 1;

    const product = await viewByProduct.findByID(proID);
    const similarProduct = await viewByProduct.findTop5ByCatDeID(product.CatDeID, proID);
    const topBidder = await viewByProduct.findTopBidder(proID);
    const productHistory = await viewByProduct.findProductHistory(proID);

    // get img in detail
    let imgs = [];
    let active = true;
    fs.readdirSync('./public/imgs/products/'+proID+'/detail/').forEach(file=>{
        if(active){
            imgs.push({name:file,first:active});
            active = false;
        }else imgs.push({name:file,first:active});
    })

    if(topBidder.length) {
        let tmp = topBidder[0].UserName;
        tmp = tmp.split("");
        topBidder[0].UserName = "";
        for (let i = 0; i / tmp.length < 0.6; i++)
            tmp[i] = '*';
        for (let i = 0; i < tmp.length; i++)
            topBidder[0].UserName += tmp[i];

        for (let i = 0; i < productHistory.length; i++) {
            tmp = productHistory[i].UserName.split("");
            for (let j = 0; j / tmp.length < 0.6; j++)
                tmp[j] = '*';
            productHistory[i].UserName = '';
            for (let k = 0; k < tmp.length; k++)
                productHistory[i].UserName += tmp[k];
        }
    }

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
            favorite, expire,seller,pending_bidder, mess,imgs,
            isLogin: req.session.isLogin,
            topBidder: topBidder[0],
            isBid: topBidder.length,
            productHistory
        });
    }else{
        res.render('product/detail', {
            product: product,
            similarProduct: similarProduct,
            isLogin: req.session.isLogin,
            topBidder: topBidder[0],
            isBid: topBidder.length,
            productHistory,imgs
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
        const product = await viewByProduct.findByID(req.query.ProID);
        const promptPrice = product.CurPrice === product.BuyNowPrice;
        const seller = await Users.findByProID(object.ProID);
        if (preBidder.length !== 0 && preBidder[0].UserID !== req.session.account.UserID){
            if(promptPrice) sendEmail(preBidder[0].UserEmail,"Đấu giá","Món hàng bạn đặt đã được mua ngay bởi người khác<div>"+req.headers.referer+"</div>");
            else sendEmail(preBidder[0].UserEmail,"Đấu giá","Món hàng bạn đặt đã được đặt giá bởi người khác :"+ "<b>"+ req.body.Price +" </b><div>"+req.headers.referer+"</div>");
        }
        if(promptPrice){

            win_list.add(object.ProID,object.BidderID);
            viewByProduct.updateStatus(0, object.ProID);
            sendEmail(seller[0].UserEmail,"Sản phẩm của bạn","Sản phẩm của bạn đã được mua ngay <div>"+req.headers.referer+"</div>");
        }
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

router.post('/detail/addFullDes',async (req, res) => {
    const product = await viewByProduct.findByID(req.body.ProID);
    const array = moment().format().split("T");
    const hour = array[1].split("+");
    const FullDes = product.FullDes + '<div class="text-center"><strong>' + array[0] + ", " + hour[0] + '</strong></div>' + req.body.FullDes;
    viewByProduct.updateFullDes(req.body.ProID, FullDes);
    res.redirect('/detail/' + req.body.ProID)
});

router.post('/detail/deleteUser',async (req, res) => {
    const Bidders = await products_history.findByProID(req.body.ProID);
    const product = await viewByProduct.findByID(req.body.ProID);
    const deleteBidder = await Users.findByID(req.body.BidderID);
    if (Bidders.length >= 2) {
        if (Bidders[0].BidderID === +req.body.BidderID) {
            let findBefore = undefined;
            for (let i = 1; i < Bidders.length; ++i) {
                if (Bidders[i].BidderID !== +req.body.BidderID) {
                    findBefore = await Users.findByID(Bidders[i].BidderID);
                    if(moment(product.EndDate)>moment()){
                        sendEmail(findBefore.UserEmail,"Đấu giá sản phẩm","<div>Bạn đang giữ giá cao nhất trong phiên đấu giá sản phẩm này</div>"+req.headers.referer);
                    }
                    viewByProduct.updatePrice(Bidders[i].Price,product.ProID);
                    break;
                }
            }
            if(findBefore === undefined){
                viewByProduct.updatePrice(product.StartPrice,product.ProID);
            }
        }
    }else viewByProduct.updatePrice(product.StartPrice,product.ProID);
    products_history.deleteByProIDAndBidderID(req.body.ProID,req.body.BidderID);
    sendEmail(deleteBidder.UserEmail,"Đấu giá sản phẩm","<div>Bạn đã bị người bán xóa khỏi cuộc đấu giá sản phẩm này</div>" + req.headers.referer);
    if(deleteBidder.UserRating < 0.8) accepted_list.delete(deleteBidder.UserID,req.body.ProID);
    banned_list.add({UserID:req.body.BidderID,ProID:req.body.ProID});
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