import knex from "../utils/db.js";

export default {
    async countByProId(ID) {
        const list = await knex('products').where('CatDeID', ID).count({amount: 'CatDeID'});
        return list[0].amount;
    },

    async findPageByCatDeId(ID, limit, offset, sort) {
        if (sort === "1") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), EndDate) diff
                                    FROM products
                                    where CatDeID = ?
                                    order by CurPrice DESC
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else if (sort === "2") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), EndDate) diff
                                    FROM products
                                    where CatDeID = ?
                                    order by CurPrice
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else if (sort === "3") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), EndDate) diff
                                    FROM products
                                    where CatDeID = ?
                                    order by diff DESC
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else if (sort === "4") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), EndDate) diff
                                    FROM products
                                    where CatDeID = ?
                                    order by diff
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else {
            return (await knex.raw(`select *,
                                           HOUR(timediff(EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), EndDate) diff
                                    FROM products
                                    where CatDeID = ?
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        }
    },
    async findByID(ID) {
        return (await knex('products').where('ProID', ID).select('*'))[0];
    },

    findCatDeName(ID) {
        return knex.select('CatDeName').from('categories_detail').where('CatDeID', ID);
    },

    async findTop5ByCatDeID(ID, exID) {
        return (await knex.raw('select *, HOUR(timediff(products.EndDate,now())) remaining, TIMESTAMPDIFF(second, now(), EndDate) diff from products where CatDeID = ? and ProID <> ? limit 0,5', [ID, exID]))[0];
    },

    findTop5Price: async function () {
        return (await knex.raw('select products.*,count(ph.ProID) bid,TIMESTAMPDIFF(second, now(), EndDate) remaining from products left join products_history ph on products.ProID = ph.ProID group by ph.ProID,products.CurPrice order by products.CurPrice desc limit 5'))[0];
    },

    findTop5Exp: async function () {
        return (await knex.raw(`select products.*,count(ph.ProID) bid, TIMESTAMPDIFF(second , now(), EndDate) remaining from products left join products_history ph on products.ProID = ph.ProID where TIMESTAMPDIFF(second , now(), EndDate) > 0 group by products.ProID order by remaining limit 5`))[0];
    },

    async findTop5Bid() {
        return (await knex.raw('select products.*,count(ph.ProID) bid, TIMESTAMPDIFF(second , now(), EndDate) remaining from products join products_history ph on products.ProID = ph.ProID group by ph.ProID order by bid desc limit 5'))[0];
    },

    async countFTS(query) {
        const list = (await knex.raw("select count(*) amount from products join categories_detail cd on products.CatDeID = cd.CatDeID where match(products.ProName) against (?)", [query]))[0];
        return list[0]["amount"];
    },

    async FTS(query, limit, offset, sort) {
        if (sort === "1") {
            return (await knex.raw("select * from products join categories_detail cd on products.CatDeID = cd.CatDeID where match(products.ProName) against (?) order by products.CurPrice desc limit ? offset ?", [query, limit, offset]))[0];
        } else if (sort === "2") {
            return (await knex.raw("select * from products join categories_detail cd on products.CatDeID = cd.CatDeID where match(products.ProName) against (?) order by products.CurPrice limit ? offset ?", [query, limit, offset]))[0];
        } else if (sort === "3") {
            return (await knex.raw("select * from products join categories_detail cd on products.CatDeID = cd.CatDeID where match(products.ProName) against (?) order by products.EndDate desc limit ? offset ?", [query, limit, offset]))[0];
        } else if (sort === "4") {
            return (await knex.raw("select * from products join categories_detail cd on products.CatDeID = cd.CatDeID where match(products.ProName) against (?) order by products.EndDate limit ? offset ?", [query, limit, offset]))[0];
        } else {
            return (await knex.raw("select * from products join categories_detail cd on products.CatDeID = cd.CatDeID where match(products.ProName) against (?) limit ? offset ?", [query, limit, offset]))[0];
        }
    },

    async findRemaining(ID) {
        const res = (await knex.raw(`select HOUR(timediff(products.EndDate, now())) remaining,
                                            TIMESTAMPDIFF(second, now(), EndDate)   diff
                                     from products
                                     where ProID = ?`, ID))[0];
        return res[0];
    },

    findByFavorite(ID,range) {
        return knex.select('products.*').from('favorite_list').leftJoin('products', 'products.ProID', 'favorite_list.ProID').where('favorite_list.UserID', ID).limit(range);
    },
    async countFindByFavorite(ID) {
        return (await knex.count('favorite_list.ProID as total').from('favorite_list').leftJoin('products', 'products.ProID', 'favorite_list.ProID').where('favorite_list.UserID', ID))[0];
    },
    updatePrice(Price, ID) {
        knex('products').where({ProID: ID}).update({CurPrice: Price}).then(() => {
        });
    },
    // async findWithTime(ID) {
    //     return (await knex.raw('select *, TIME_TO_SEC(timediff(products.EndDate,now())) time from products where ProID = '+ID))[0];
    // },
    updateStatusEndBidding(ID) {
        knex('products').where({ProID: ID}).update({Status: 0,Mail: 1}).then(() => {
        });
    },

    async findTopBidder(ID) {
        const maxPrice = (await knex.raw(`select *
                                          from products_history
                                          where BidID >= all (select BidID from products_history where ProID = ?)
                                            and ProID = ?`, [+ID, +ID]))[0][0];
        if (maxPrice === undefined)
            return [];
        return (await knex('users').where('UserID', maxPrice.BidderID));
    },

    async findProductHistory(ID) {
        return (await knex.raw(`select BidDate, Price, UserName, BidderID, UserID
                                from products_history,
                                     users
                                where BidderID = UserID
                                  and ProID = ?
                                  ORDER BY BidID`, +ID))[0];
    },

    findBySeller(userID,range) {
        return knex.select('products.*').from('products').join('users', 'products.SellerID', 'users.UserID').where('users.UserID', userID).limit(range);
    },

    async countFindBySeller(userID) {
        return (await knex.count('products.ProID as total').from('products').join('users', 'products.SellerID', 'users.UserID').where('users.UserID', userID))[0];
    },
    addProducts(object) {
        return knex('products').insert(object);
    },
    updateFullDes(ProID, FullDes) {
        knex('products').where('ProID', ProID).update('FullDes', FullDes).then(() => {
        });
    },
    findAll() {
        return knex('products');
    },
    async del(ID) {
        await knex('win_list').where('ProID', +ID).del();
        await knex('favorite_list').where('ProID', +ID).del();
        await knex('products_history').where('ProID', +ID).del();
        await knex('pending_list').where('ProID', +ID).del();
        // await knex.raw(`update rating_list set ProID = null where ProID = ?`, +ID);
        return knex('products').where('ProID', +ID).del();
    },
    updateMinute(ID) {
        knex.raw('update products set products.EndDate = addtime(products.EndDate,\'00:10:00\') where products.ProID = ?', ID).then(() => {
        });
    },

    findByWinList(UserID) {
        return knex.select('*').from('win_list').leftJoin('products', 'products.ProID', 'win_list.ProID').where('win_list.UserID', UserID);
    },
    async findToRating(ProID) {
        return (await knex.select('*').from('products').join('users', 'users.UserID', 'products.SellerID').where('products.ProID', ProID))[0];
    },
    async findEndBidding(SellerID) {
        return (await knex.raw('select * from products where (now() > products.EndDate or products.CurPrice = products.BuyNowPrice) and products.SellerID = ?', [SellerID]))[0];

    },
    findUserEmail(ID) {
        return knex.select('UserEmail').from('users').where('UserID', ID);
    },
    findSeller(ID) {
        return knex('users').where('UserID', ID);
    },
    async findProductEndBiddingWithCron() {
        const productExpire = (await knex.raw('select products.ProID, users.UserEmail sellerMail  from products join users on users.UserID = products.SellerID where TIMESTAMPDIFF(second , now(), EndDate) <= 0 and products.Mail = false and products.Status = 1'))[0];
        for (let i=0;i<productExpire.length;++i){
            const bidder = await knex.select('*').from('users').join('products_history','products_history.BidderID','users.UserID').where('products_history.ProID',productExpire[i].ProID).orderBy('products_history.BidID','desc').limit(1);
            if(bidder.length === 0) productExpire[i].bidderMail = null;
            else {
                productExpire[i].bidderMail = bidder[0].UserEmail;
                productExpire[i].bidderID = bidder[0].UserID;
            }
            this.updateStatusEndBidding(productExpire[i].ProID);
        }
        return productExpire;
    }
}