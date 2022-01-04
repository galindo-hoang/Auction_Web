import knex from "../utils/db.js";

const entity = {
    async insert(entity){
        return knex('update_users').insert(entity);
    },
    getUserID(ID){
        return knex('update_users').where('UserID', ID);
    }
}

export default entity;