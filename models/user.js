import knex from "../utils/db.js";

const entity = {
    addUser: function(object){
        knex.table('users').insert(object).then(()=>{});
    },
    findByUserName: function (username){
        return knex.table('users').where('username',username);
    },
    findByID: async function (ID) {
        return (await knex.table('users').where('id', ID))[0];
    }
}

export default entity;