import knex from "../utils/db.js";

export default {
    async countByProId(ID) {
        const list = await knex('products').where('CatDeID', ID).count({ amount: 'CatDeID' });
        return list[0].amount;
    },
    async findPageByCatDeId(ID, limit, offset){
        return (await knex.raw(`select *, HOUR(timediff(products.EndDate, now())) remaining
                            from products 
                            where CatDeID = ?`, ID))[0];
    },
    findCatDeName(ID){
        return knex.select('CatDeName').from('categories_detail').where('CatDeID', ID);
    },

    findTop5Price: async function () {
        return (await knex.raw('select *,HOUR(timediff(products.EndDate,now())) remaining from products order by CurPrice desc limit 5'))[0];
    },

    findTop5Exp: async function () {
        return (await knex.raw(`select *,HOUR(timediff(products.EndDate,now())) remaining from products where timediff(products.EndDate,now()) > 0 order by TIME_TO_SEC(timediff(products.EndDate,now())) LIMIT 5`))[0];
    },

    async countFTS(query) {
        const list = await knex.select('*').from('categories_detail').leftJoin('products', 'categories_detail.CatDeID', 'products.CatDeID').where('products.ProName', 'like', '%' + query + '%').orWhere('categories_detail.CatDeName', 'like', '%' + query + '%').count({amount: 'products.ProID'});
        return list[0].amount;
    },

    FTS(query,limit,offset,sort){
        if(sort === "1"){
            return knex.select('*').from('categories_detail').leftJoin('products','categories_detail.CatDeID','products.CatDeID').where('products.ProName','like','%'+query+'%').orWhere('categories_detail.CatDeName','like','%'+query+'%').orderBy('products.CurPrice','desc').limit(limit).offset(offset);
        }else if(sort === "2"){
            return knex.select('*').from('categories_detail').leftJoin('products','categories_detail.CatDeID','products.CatDeID').where('products.ProName','like','%'+query+'%').orWhere('categories_detail.CatDeName','like','%'+query+'%').orderBy('products.CurPrice').limit(limit).offset(offset);
        }else if(sort === "3"){
            return knex.select('*').from('categories_detail').leftJoin('products','categories_detail.CatDeID','products.CatDeID').where('products.ProName','like','%'+query+'%').orWhere('categories_detail.CatDeName','like','%'+query+'%').orderBy('products.EndDate','desc').limit(limit).offset(offset);
        }else {
            return knex.select('*').from('categories_detail').leftJoin('products','categories_detail.CatDeID','products.CatDeID').where('products.ProName','like','%'+query+'%').orWhere('categories_detail.CatDeName','like','%'+query+'%').orderBy('products.EndDate').limit(limit).offset(offset);
        }
    },

    async findRemaining(ID){
        const res = (await knex.raw(`select HOUR(timediff(products.EndDate,now())) remaining from products where ProID = ?`, ID))[0];
        return res[0].remaining;
    }
}