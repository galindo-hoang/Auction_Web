import knex from '../utils/db.js';

const entity = {
    add: function (object){
        knex('accepted_list').insert(object).then(()=>{});
    },
    find(UserID, ProID) {
        return knex('accepted_list').select('*').where({UserID: UserID, ProID:ProID});
    },
    delete(UserID, ProID) {
        knex('accepted_list').where({UserID,ProID}).del().then(()=>{});
    }
}

export default entity;