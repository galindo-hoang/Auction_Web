import knex from "../utils/db.js";

const entity = {
    find: function(userid,proid){
        return knex('favorite_list').select('*').where({
            UserID: userid,
            ProID: proid
        })
    },
    add: function(object){
        knex('favorite_list').insert(object).then(()=>{});
    },
    remove: function(userid,proid){
        knex('favorite_list').where({
            UserID:userid,
            ProID: proid
        }).delete().then(()=>{});
    }
}

export default entity;
