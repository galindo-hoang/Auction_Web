import cron from "cron";
import Product from "../models/product.js";
import sendEmail from "./mail.js";
import win_list from "../models/win_list.js";

const updateExpire = async function () {
    const data = await Product.findProductEndBiddingWithCron();
    for (const dataKey in data) {
        sendEmail(dataKey.sellerMail, "Sản phẩm của bạn", "Sản phẩm của bạn đã hết hạn đấu giá <div>" + "http://localhost:3000/detail/" + dataKey.ProID + "</div>");
        if(dataKey.bidderMail){
            win_list.add(dataKey.ProID,dataKey.bidderID);
            sendEmail(dataKey.bidderMail, "Đấu giá", "Bạn đã thắng đấu giá sản phẩm <div>" + "http://localhost:3000/detail/" + dataKey.ProID + "</div>");
        }
    }
}

const cronJob = new cron.CronJob({
    cronTime: '* * * * * *',
    onTick: updateExpire,
    start: true,
    timeZone: 'Asia/Ho_Chi_Minh',
});

export default cronJob;
