import cron from "cron";
import Product from "../models/product.js";
import sendEmail from "./mail.js";
import win_list from "../models/win_list.js";

const updateExpire = async function () {
    const data = await Product.findProductEndBiddingWithCron();
    for (const dataKey in data) {
        sendEmail(data[dataKey].sellerMail, "Sản phẩm của bạn", "Sản phẩm của bạn đã hết hạn đấu giá <div>" + "http://localhost:3000/detail/" + data[dataKey].ProID + "</div>");
        if(data[dataKey].bidderMail){
            win_list.add(data[dataKey].ProID,data[dataKey].bidderID);
            sendEmail(data[dataKey].bidderMail, "Đấu giá", "Bạn đã thắng đấu giá sản phẩm <div>" + "http://localhost:3000/detail/" + data[dataKey].ProID + "</div>");
        }
    }
}

const cronJob = new cron.CronJob({
    cronTime: '* * * * *',
    onTick: updateExpire,
    start: true,
    timeZone: 'Asia/Ho_Chi_Minh',
});

export default cronJob;
