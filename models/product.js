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
    },

    findTop5Price: function (){
        return knex('products').select('*').limit(5).orderBy('CurPrice','desc');
    },

    findTop5Exp: async function () {
        return (await knex.raw(`select *,HOUR(timediff(products.EndDate,now())) remaining from products where timediff(products.EndDate,now()) > 0 order by TIME_TO_SEC(timediff(products.EndDate,now())) LIMIT 5`))[0];
    }
}