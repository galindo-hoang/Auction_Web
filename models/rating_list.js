import knex from "../utils/db.js"

const entity = {
    add(object){
        knex('rating_list').insert(object).then(()=>{});
    },
    async findByProIDUserRateID(ProID, UserRateID) {
        return (await knex('rating_list').select('*').where({ProID, UserRateID}))[0];
    },
    async findByUserID(UserID) {
        return knex.select('*').from('rating_list').join('users', 'users.UserID', 'rating_list.UserID').where('users.UserID', +UserID);
    },
    async findByUserRateID(UserRateID) {
        return knex.select('*').from('rating_list').join('users', 'users.UserID', 'rating_list.UserRateID').where('rating_list.UserID', +UserRateID);
    }
}

export default entity;