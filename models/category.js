import knex from "../utils/db.js";

export default {
    findAll(){
        return knex('categories').select('*');
    },
    async countByCatId(ID) {
        const list = await knex.raw(`select COUNT(ProID) AS ProductCount
                                     FROM products p, categories_detail cd, categories c
                                     where c.CatID = cd.CatID AND cd.CatDeID = p.CatDeID AND c.CatID = ?`, ID);
        return list[0][0];
    },
    async findPageByCatId(ID, limit, offset, sort){
        if(sort === "1"){
            return (await knex.raw(`select *, HOUR(timediff(p.EndDate, now())) remaining
                                     FROM products p, categories_detail cd, categories c
                                     where c.CatID = cd.CatID AND cd.CatDeID = p.CatDeID AND c.CatID = ?
                                     order by p.CurPrice DESC
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }else if(sort === "2"){
            return (await knex.raw(`select *, HOUR(timediff(p.EndDate, now())) remaining
                                     FROM products p, categories_detail cd, categories c
                                     where c.CatID = cd.CatID AND cd.CatDeID = p.CatDeID AND c.CatID = ?
                                     order by p.CurPrice
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }else if(sort === "3"){
            return (await knex.raw(`select *, HOUR(timediff(p.EndDate, now())) remaining
                                     FROM products p, categories_detail cd, categories c
                                     where c.CatID = cd.CatID AND cd.CatDeID = p.CatDeID AND c.CatID = ?
                                     order by remaining DESC
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }else {
            return (await knex.raw(`select *, HOUR(timediff(p.EndDate, now())) remaining
                                     FROM products p, categories_detail cd, categories c
                                     where c.CatID = cd.CatID AND cd.CatDeID = p.CatDeID AND c.CatID = ?
                                     order by remaining
                                        LIMIT ?, ?`, [ID, offset, limit]))[0];
        }
    },
    findCatName(ID){
        return knex.select('CatName').from('categories').where('CatID', ID);
    },
}