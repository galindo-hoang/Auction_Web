import cron from "cron";

const updateExpire = function (){
    console.log('cc');
}

const cronJob = new cron.CronJob({
    cronTime: '* * * * * *',
    onTick: updateExpire,
    start: true,
    timeZone: 'Asia/Ho_Chi_Minh',
});

export default cronJob;
