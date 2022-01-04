import knex from "../utils/db.js";

const entity = {
    add: function (object){
        knex('products_history').insert(object).then(()=>{});
    },
    // findByBidderID: function (BidderID){
    //     return knex('products_history').select('*').where('BidderID',BidderID);
    // },
    findByTracking(UserID) {
        return knex.select('products_history.*','products.EndDate','products.TinyDes').from('products_history').leftJoin('products','products.ProID','products_history.ProID').where('products_history.BidderID',UserID);
    },
    findByBidderIDAndProID(BidderID, ProID) {

    },
    findByProID(ProID) {
        return knex('products_history').select('*').where('ProID',ProID).orderBy('Price',"desc");
    },
    deleteByProIDAndBidderID(ProID, BidderID) {
        knex('products_history').where({BidderID:BidderID,ProID:ProID}).del().then(()=>{});
    },
    async findBidderAndCount(ProID) {
        return knex.select('users.UserName').from('products_history').join('users', 'users.UserID', 'products_history.BidderID').where('products_history.ProID', ProID).groupBy('products_history.BidID').orderBy('products_history.BidID', 'desc');
    }
}

export default entity;
