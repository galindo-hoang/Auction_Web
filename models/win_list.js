import knex from "../utils/db.js";

const entity = {
    add(ProID,UserID){
        knex('win_list').insert({ProID,UserID}).then(()=>{});
    },
    async findByRating(ProID, UserID) {
        return (await knex.raw("select * from win_list left join rating_list rl on win_list.ProID = rl.ProID and rl.UserRateID = win_list.UserID where win_list.ProID = (?) and rl.UserRateID = (?)", [ProID, UserID]))[0];
    },
    async findByProID(ProID) {
        return (await knex.select('users.*').from('win_list').join('users', 'users.UserID', 'win_list.UserID').where('win_list.ProID', ProID))[0];
    }
}

export default entity;