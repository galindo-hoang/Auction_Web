import knex from '../utils/db.js';

const entity = {
    add: function (object){
        knex('pending_list').insert(object).then(()=>{});
    },
    find: function (BidderID,ProID){
        return knex('pending_list').select('*').where({UserID:BidderID,ProID:ProID});
    },
    remove(BidderID, ProID) {
        knex('pending_list').where({UserID:BidderID, ProID:ProID}).del().then(()=>{});
    }
}

export default entity;