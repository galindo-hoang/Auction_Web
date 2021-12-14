import knex from "../utils/db.js";

export default {
    async countByProId(ID) {
        const list = await knex('products').where('CatDeID', ID).count({ amount: 'CatDeID' });
        return list[0].amount;
    },

    async findPageByCatDeId(ID, limit, offset, sort){
        if(sort === "1"){
            return (await knex.raw(`select *, HOUR(timediff(EndDate, now())) remaining
                                     FROM products
                                     where CatDeID = ?
                                     order by CurPrice DESC
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }else if(sort === "2"){
            return (await knex.raw(`select *, HOUR(timediff(EndDate, now())) remaining
                                    FROM products
                                    where CatDeID = ?
                                    order by CurPrice
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }else if(sort === "3"){
            return (await knex.raw(`select *, HOUR(timediff(EndDate, now())) remaining
                                    FROM products
                                    where CatDeID = ?
                                    order by remaining DESC
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }else {
            return (await knex.raw(`select *, HOUR(timediff(EndDate, now())) remaining
                                    FROM products
                                    where CatDeID = ?
                                    order by remaining
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }
    },
    async findByID(ID){
        return (await knex('products').where('ProID', ID))[0];
    },

    findCatDeName(ID){
        return knex.select('CatDeName').from('categories_detail').where('CatDeID', ID);
    },

    async findTop5ByCatDeID(ID, exID){
        return (await knex.raw('select *, HOUR(timediff(products.EndDate,now())) remaining from products where CatDeID = ? and ProID <> ? limit 0,5', [ID, exID]))[0];
    },

    findTop5Price: async function () {
        return (await knex.raw('select *,HOUR(timediff(products.EndDate,now())) remaining from products order by CurPrice desc limit 5'))[0];
    },

    findTop5Exp: async function () {
        return (await knex.raw(`select *,HOUR(timediff(products.EndDate,now())) remaining from products where timediff(products.EndDate,now()) > 0 order by TIME_TO_SEC(timediff(products.EndDate,now())) LIMIT 5`))[0];
    },

    async countFTS(query) {
        const list = (await knex.raw("select count(*) amount from products left join categories_detail cd on products.CatDeID = cd.CatDeID where match(cd.CatDeName) against(?) or match(products.ProName) against (?)", [query, query]))[0];
        return list[0]["amount"];
    },

    async FTS(query, limit, offset, sort) {
        if (sort === "1") {
            return (await knex.raw("select * from products left join categories_detail cd on products.CatDeID = cd.CatDeID where match(cd.CatDeName) against(?) or match(products.ProName) against (?) order by products.CurPrice desc limit ? offset ?", [query, query, limit, offset]))[0];
        } else if (sort === "2") {
            return (await knex.raw("select * from products left join categories_detail cd on products.CatDeID = cd.CatDeID where match(cd.CatDeName) against(?) or match(products.ProName) against (?) order by products.CurPrice limit ? offset ?", [query, query, limit, offset]))[0];
        } else if (sort === "3") {
            return (await knex.raw("select * from products left join categories_detail cd on products.CatDeID = cd.CatDeID where match(cd.CatDeName) against(?) or match(products.ProName) against (?) order by products.EndDate desc limit ? offset ?", [query, query, limit, offset]))[0];
        } else if (sort === "4") {
            return (await knex.raw("select * from products left join categories_detail cd on products.CatDeID = cd.CatDeID where match(cd.CatDeName) against(?) or match(products.ProName) against (?) order by products.EndDate limit ? offset ?", [query, query, limit, offset]))[0];
        } else {
            return (await knex.raw("select * from products left join categories_detail cd on products.CatDeID = cd.CatDeID where match(cd.CatDeName) against(?) or match(products.ProName) against (?) limit ? offset ?", [query, query, limit, offset]))[0];
        }
    },

    async findRemaining(ID){
        const res = (await knex.raw(`select HOUR(timediff(products.EndDate,now())) remaining from products where ProID = ?`, ID))[0];
        return res[0].remaining;
    },

    findByFavorite(ID){
        return knex.select('products.*').from('favorite_list').leftJoin('products','products.ProID','favorite_list.ProID').where('favorite_list.UserID',ID);
    },
    updatePrice(Price,ID) {
        knex('products').where({ProID:ID}).update({CurPrice:Price}).then(()=>{});
    },
    // async findWithTime(ID) {
    //     return (await knex.raw('select *, TIME_TO_SEC(timediff(products.EndDate,now())) time from products where ProID = '+ID))[0];
    // },
    updateStatus(Status,ID){
        knex('products').where({ProID:ID}).update({Status:Status}).then(()=>{});
    },

    async findTopBidder(ID){
        const maxPrice =  (await knex.raw(`select * from products_history where BidID >= all (select BidID from products_history where ProID = ?) and ProID = ?`, [+ID, +ID]))[0][0];
        if(maxPrice === undefined)
            return [];
        return (await knex('users').where('UserID', maxPrice.BidderID));
    },

    async findProductHistory(ID){
      return (await knex.raw(`select BidDate, Price, UserName from products_history, users where BidderID = UserID and ProID = ?`, +ID))[0];
    }

}