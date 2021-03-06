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

import {addBidAndUserMaxBid} from "../app.js"
import rating_list from "../models/rating_list.js";

router.get('/detail/:id', async (req, res) => {
    const proID = req.params.id || 1;

    const product = await viewByProduct.findByID(proID);
    if(product === undefined) res.redirect("/");
    else{
        const similarProduct = await viewByProduct.findTop5ByCatDeID(product.CatDeID, proID);
        for (let i = 0; i < similarProduct.length; i++){
            similarProduct[i].exp = similarProduct[i].diff < 0;
            similarProduct[i].isNew = +similarProduct[i].processing >= 0 && +similarProduct[i].processing <= 3600;
            addBidAndUserMaxBid(similarProduct[i]).then(()=>{});
        }

        const topBidder = await viewByProduct.findTopBidder(proID);
        const productHistory = await viewByProduct.findProductHistory(proID);

        // get img in detail
        let imgs = [];
        let active = true;
        fs.readdirSync('./public/imgs/products/' + proID + '/detail/').forEach(file => {
            if (active) {
                imgs.push({name: file, first: active});
                active = false;
            } else imgs.push({name: file, first: active});
        })

        if (topBidder.length) {
            let tmp = topBidder[0].UserName;
            tmp = tmp.split("");
            topBidder[0].UserName = "";
            for (let i = 0; i / tmp.length < 0.5; i++)
                tmp[i] = '*';
            for (let i = 0; i < tmp.length; i++)
                topBidder[0].UserName += tmp[i];

            for (let i = 0; i < productHistory.length; i++) {
                tmp = productHistory[i].UserName.split("");
                for (let j = 0; j / tmp.length < 0.5; j++)
                    tmp[j] = '*';
                productHistory[i].UserName = '';
                for (let k = 0; k < tmp.length; k++)
                    productHistory[i].UserName += tmp[k];
            }
        }
        const proSeller = await viewByProduct.findSeller(product.SellerID);
        const prevPage = req.headers.referer;
        if (req.session.isLogin) {
            let mess = "";
            const banned = ((await banned_list.find(req.session.account.UserID, req.params.id)).length === 1);
            if (+req.session.account[req.params.id] === 1) {
                mess = "Ch??ng t??i ???? th??m b???n v??o h??ng ch???";
                delete req.session.account[req.params.id];
            } else if (+req.session.account[req.params.id] === 0) {
                mess = "B???n ??ang ch??? quy???t ?????nh c???a ng?????i b??n";
                delete req.session.account[req.params.id];
            }
            const favorite = await favorite_list.find(req.session.account.UserID, req.params.id);
            const expire = moment(product.EndDate) < moment() || product.CurPrice === product.BuyNowPrice || banned || !product.Status;
            const seller = product.SellerID === req.session.account.UserID;
            let pending_bidder = [];
            if (seller) {
                pending_bidder = await Users.findUserPendingByProID(req.params.id);
            }
            if(!expire) product.SuggestPrice = product.CurPrice + product.StepPrice;
            res.render('product/detail', {
                product: product,
                similarProduct: similarProduct,
                favorite, expire, seller, pending_bidder, mess, imgs,
                isLogin: req.session.isLogin,
                topBidder: topBidder[0],
                isBid: topBidder.length,
                productHistory,
                Seller: proSeller[0],
                prevPage
            });
        } else {
            const expire = moment(product.EndDate) < moment() || product.CurPrice === product.BuyNowPrice || !product.Status;
            res.render('product/detail', {
                product: product,
                similarProduct: similarProduct,
                isLogin: req.session.isLogin,
                isBid: topBidder.length,
                topBidder: topBidder[0],
                imgs,
                Seller: proSeller[0],
                prevPage,
                expire
            });
        }

    }
});

router.post('/bid', auth.beforeLogin, async (req, res) => {
    const accepted = await accepted_list.find(req.session.account.UserID, req.query.ProID);
    const pending = await pending_list.find(req.session.account.UserID, req.query.ProID);
    if ((req.session.account.UserRating >= 0.8 && pending.length === 0) || accepted.length !== 0) {
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
        const promptPrice = +object.Price === +product.BuyNowPrice;
        const seller = await Users.findByProID(object.ProID);
        if (preBidder.length !== 0 && preBidder[0].UserID !== req.session.account.UserID) {
            if (promptPrice) sendEmail(preBidder[0].UserEmail, "?????u gi??", "M??n h??ng b???n ?????t ???? ???????c mua ngay b???i ng?????i kh??c<div>" + req.headers.referer + "</div>");
            else sendEmail(preBidder[0].UserEmail, "?????u gi??", "M??n h??ng b???n ?????t ???? ???????c ?????t gi?? b???i ng?????i kh??c :" + "<b>" + req.body.Price + " </b><div>" + req.headers.referer + "</div>");
        }
        if (promptPrice) {

            win_list.add(object.ProID, object.BidderID);
            viewByProduct.updateStatusEndBidding(object.ProID);
            sendEmail(seller[0].UserEmail, "S???n ph???m c???a b???n", "S???n ph???m c???a b???n ???? ???????c mua ngay <div>" + req.headers.referer + "</div>");
        } else {
            if(product.AutoExtend){
                const now = moment();
                const endDate = moment(product.EndDate);
                if(now.diff(endDate,'minutes') < 5) viewByProduct.updateMinute(req.query.ProID);
            }
            sendEmail(seller[0].UserEmail, "S???n ph???m c???a b???n", "S???n ph???m c???a b???n ???? ???????c ?????t v???i m???c gi??: <b>" + req.body.Price + "</b><div>" + req.headers.referer + "</div>");
        }

        sendEmail(req.session.account.UserEmail, "ch??c m???ng", "b???n ???? ra gi?? th??nh c??ng m??n h??ng<div>" + req.headers.referer + "</div>");


        res.redirect('/detail/' + object.ProID);
    } else {
        if (pending.length === 0) {
            pending_list.add({UserID: req.session.account.UserID, ProID: req.query.ProID});
            req.session.account["" + req.query.ProID] = 1;
            res.redirect('/detail/' + req.query.ProID);
        } else {
            req.session.account["" + req.query.ProID] = 0;
            res.redirect('/detail/' + req.query.ProID);
        }
    }
});

router.post('/detail/denyPending', async (req, res) => {
    pending_list.remove(req.body.BidderID, req.body.ProID);
    banned_list.add({UserID: req.body.BidderID, ProID: req.body.ProID});
    res.redirect('/detail/' + req.body.ProID);
});

router.post('/detail/acceptPending', async (req, res) => {
    pending_list.remove(req.body.BidderID, req.body.ProID);
    accepted_list.add({UserID: req.body.BidderID, ProID: req.body.ProID});
    const bidder = await Users.findByID(req.body.BidderID);
    sendEmail(bidder.UserEmail, "?????u gi?? s???n ph???m", "<div>b???n ???? ???????c c???p quy???n ?????u gi?? s???n ph???m</div>" + req.headers.referer);
    res.redirect('/detail/' + req.body.ProID);
})

router.post('/detail/addFullDes', async (req, res) => {
    const product = await viewByProduct.findByID(req.body.ProID);
    const array = moment().format().split("T");
    const hour = array[1].split("+");
    const FullDes = product.FullDes + '<div class="text-center"><strong>' + array[0] + ", " + hour[0] + '</strong></div>' + req.body.FullDes;
    viewByProduct.updateFullDes(req.body.ProID, FullDes);
    res.redirect('/detail/' + req.body.ProID)
});

router.post('/detail/deleteUser', async (req, res) => {
    const Bidders = await products_history.findByProID(req.body.ProID);
    const product = await viewByProduct.findByID(req.body.ProID);
    const deleteBidder = await Users.findByID(req.body.BidderID);
    if (Bidders.length >= 2) {
        if (Bidders[0].BidderID === +req.body.BidderID) {
            let findBefore = undefined;
            for (let i = 1; i < Bidders.length; ++i) {
                if (Bidders[i].BidderID !== +req.body.BidderID) {
                    findBefore = await Users.findByID(Bidders[i].BidderID);
                    if (moment(product.EndDate) > moment()) {
                        sendEmail(findBefore.UserEmail, "?????u gi?? s???n ph???m", "<div>B???n ??ang gi??? gi?? cao nh???t trong phi??n ?????u gi?? s???n ph???m n??y</div>" + req.headers.referer);
                    }
                    viewByProduct.updatePrice(Bidders[i].Price, product.ProID);
                    break;
                }
            }
            if (findBefore === undefined) {
                viewByProduct.updatePrice(product.StartPrice, product.ProID);
            }
        }
    } else viewByProduct.updatePrice(product.StartPrice, product.ProID);
    products_history.deleteByProIDAndBidderID(req.body.ProID, req.body.BidderID);
    sendEmail(deleteBidder.UserEmail, "?????u gi?? s???n ph???m", "<div>B???n ???? b??? ng?????i b??n x??a kh???i cu???c ?????u gi?? s???n ph???m n??y</div>" + req.headers.referer);
    if (deleteBidder.UserRating < 0.8) accepted_list.delete(deleteBidder.UserID, req.body.ProID);
    banned_list.add({UserID: req.body.BidderID, ProID: req.body.ProID});
    res.redirect('/detail/' + req.body.ProID);
})


router.post('/favorite', auth.beforeLogin, async (req, res) => {
    const data = await favorite_list.find(req.query.UserID, req.query.ProID);
    if (data.length === 0) {
        favorite_list.add({ProID: req.query.ProID, UserID: req.query.UserID});
    } else {
        favorite_list.remove(req.query.UserID, req.query.ProID);
    }
    res.redirect(("/detail/" + req.query.ProID).trim());
});

router.get('/getReview/detail',async (req,res)=>{
    const data = await rating_list.findByUserID(req.query.id);
    res.json(data);
})

export default router;