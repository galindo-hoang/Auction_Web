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
    }
}

export default entity;
