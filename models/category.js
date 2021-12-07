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
    async findPageByCatId(ID, limit, offset){
        const list = await knex.raw(`select *, HOUR(timediff(p.EndDate, now())) remaining
                                     FROM products p, categories_detail cd, categories c
                                     where c.CatID = cd.CatID AND cd.CatDeID = p.CatDeID AND c.CatID = ?
                                         LIMIT ?, ?`, [ID, offset, limit]);
        return list[0];
    },
    findCatName(ID){
        return knex.select('CatName').from('categories').where('CatID', ID);
    },
}