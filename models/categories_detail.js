import knex from "../utils/db.js";

const entity = {
    findByCatID: function (CatID){
        return knex.table('categories_detail').where('CatiD',CatID);
    },
    // findAllProByCatDeID: function (CatDeID){
    //     return
    // }
}

export default entity;