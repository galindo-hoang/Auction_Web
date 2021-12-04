import knex from "../utils/db.js";

const entity = {
    addUser: function(object){
        knex.table('users').insert(object).then(()=>{});
    },
    findByEmail: function (email){
        return knex.table('users').where('email',email);
    },
    findByID: async function (ID) {
        if(ID !== undefined) return (await knex.table('users').where('id', ID))[0];
        return undefined;
    }
}

export default entity;