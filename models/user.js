import knex from "../utils/db.js";
import bcrypt from "bcryptjs";

const entity = {
    addUser: function(object){
        knex.table('users').insert(object).then(()=>{});
    },
    findByEmail: function (email){
        return knex.table('users').where('UserEmail',email);
    },
    findByID: async function (ID) {
        if(ID !== undefined) return (await knex.table('users').where('UserID', ID))[0];
        return undefined;
    },
    changePassword: function (email, pass){
        knex.table('users').where('UserEmail',email).update({UserPassword:pass}).then(()=>{});
    },
    updateUser(pass,date,name,email){
        const salt = bcrypt.genSaltSync(10);
        const password = bcrypt.hashSync(pass, salt);
        knex.table('users').where('UserEmail',email).update({
            UserPassword: password,
            DOB: date,
            UserName:name
        }).then(()=>{});
    },
    updateUserWithoutPass(date,name,email){
        knex.table('users').where('UserEmail',email).update({
            DOB: date,
            UserName:name
        }).then(()=>{});
    },
    findByProID(ProID) {
        return knex.select('users.*').from('products').leftJoin('users','users.UserID','products.SellerID').where('ProID',ProID);
    },
    findPreBidderByID(ProID) {
        return knex.select('users.*').from('users').leftJoin('products_history','users.UserID','products_history.BidderID').where('ProID',ProID).orderBy('Price','desc').limit(1);
    },
    findUserPendingByProID(ProID){
        return knex.select('users.*').from('pending_list').leftJoin('users','users.UserID','pending_list.UserID').where('pending_list.ProID',ProID);
    },
    findAll(){
        return knex('users').whereRaw('UserRole <> ?', 0);
    },
    findAllSeller(){
        return knex('users').where('UserRole', 1);
    },
    // findAllBidder(){
    //     return knex('users').where('UserRole', 2);
    // },
    async requireUpdate(){
        return (await knex.raw(`select * from users us, update_users ud where us.UserID = ud.UserID`))[0];
    },
    async changeRole(ID, role){
        await knex.raw(`UPDATE users
                        SET UserRole = ?
                        WHERE UserID = ?`, [role, ID]);
        await knex('update_users').where('UserID', ID).del();
    },
    async del(ID){
        const role = await knex.select('UserRole').from('users').where('UserID', ID);
        console.log(role[0].UserRole);
        if(+role[0].UserRole === 1) {
            await knex('products').where("SellerID", ID).del();
        }
        return knex('users').where('UserID', ID).del();
    },
    updateRating(UserID,UserRating) {
        knex('users').update({UserRating}).where({UserID}).then(()=>{});
    }
}

export default entity;