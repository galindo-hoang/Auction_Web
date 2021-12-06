import knex from "../utils/db.js";

export default {
    async countByProId(ID) {
        const list = await knex('products').where('CatDeID', ID).count({ amount: 'CatDeID' });
        return list[0].amount;
    },
    async findPageByProId(ID, limit, offset){
        return knex('products').where('CatDeID', ID).limit(limit).offset(offset);
    },
    findCatDeName(ID){
        return knex.select('CatDeName').from('categories_detail').where('CatDeID', ID);
    }
}