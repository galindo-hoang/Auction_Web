import knex from "../utils/db.js";

const entity = {
    findByCatID: function (CatID){
        return knex.table('categories_detail').where('CatID',CatID);
    },
    async del(ID) {
        const check = (await(knex.raw(`select COUNT(*) as ProCount
                                  from products p, categories_detail cd
                                  where cd.CatDeID = p.CatDeID AND cd.CatDeID = ?`, ID)))[0][0].ProCount;
        if(check)
            return null;
        return knex('categories_detail').where('CatDeID', ID).del();
    },
    findByCatDeID(ID){
        return knex('categories_detail').where('CatDeID', ID);
    },
    async saveEdit(obj){
        const ID = obj.CatDeID;
        delete obj.CatDeID;
        return knex('categories_detail').where('CatDeID', ID).update(obj);
    },
    async add(obj){
        return knex('categories_detail').insert(obj);
    }
}

export default entity;