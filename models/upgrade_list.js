import knex from "../utils/db.js";

const entity = {
    async insert(entity){
        return knex('update_users').insert(entity);
    },
    getUserID(ID){
        return knex('update_users').where('UserID', ID);
    },
    async del(ID) {
        await knex('update_users').where('UserID', ID).del();
    }
}

export default entity;