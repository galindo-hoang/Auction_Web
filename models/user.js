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
    }
}

export default entity;