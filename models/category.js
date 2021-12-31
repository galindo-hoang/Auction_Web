import knex from "../utils/db.js";

export default {
    findAll() {
        return knex('categories').select('*');
    },
    async countByCatId(ID) {
        const list = await knex.raw(`select COUNT(ProID) AS ProductCount
                                     FROM products p,
                                          categories_detail cd,
                                          categories c
                                     where c.CatID = cd.CatID
                                       AND cd.CatDeID = p.CatDeID
                                       AND c.CatID = ?`, ID);
        return list[0][0];
    },
    async findPageByCatId(ID, limit, offset, sort) {
        if (sort === "1") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(p.EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), p.EndDate) diff
                                    FROM products p,
                                         categories_detail cd,
                                         categories c
                                    where c.CatID = cd.CatID
                                      AND cd.CatDeID = p.CatDeID
                                      AND c.CatID = ?
                                    order by p.CurPrice DESC
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else if (sort === "2") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(p.EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), p.EndDate) diff
                                    FROM products p,
                                         categories_detail cd,
                                         categories c
                                    where c.CatID = cd.CatID
                                      AND cd.CatDeID = p.CatDeID
                                      AND c.CatID = ?
                                    order by p.CurPrice
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else if (sort === "3") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(p.EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), p.EndDate) diff
                                    FROM products p,
                                         categories_detail cd,
                                         categories c
                                    where c.CatID = cd.CatID
                                      AND cd.CatDeID = p.CatDeID
                                      AND c.CatID = ?
                                    order by diff DESC
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else if (sort === "4") {
            return (await knex.raw(`select *,
                                           HOUR(timediff(p.EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), p.EndDate) diff
                                    FROM products p,
                                         categories_detail cd,
                                         categories c
                                    where c.CatID = cd.CatID
                                      AND cd.CatDeID = p.CatDeID
                                      AND c.CatID = ?
                                    order by diff
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        } else {
            return (await knex.raw(`select *,
                                           HOUR(timediff(p.EndDate, now()))        remaining,
                                           TIMESTAMPDIFF(second, now(), p.EndDate) diff
                                    FROM products p,
                                         categories_detail cd,
                                         categories c
                                    where c.CatID = cd.CatID
                                      AND cd.CatDeID = p.CatDeID
                                      AND c.CatID = ?
                                    LIMIT ?, ?`, [ID, offset, limit]))[0];
        }
    },
    findCatName(ID) {
        return knex.select('CatName').from('categories').where('CatID', ID);
    },
    async del(ID) {
        const check = (await (knex.raw(`select COUNT(*) as ProCount
                                        from products p,
                                             categories_detail cd,
                                             categories c
                                        where c.CatID = cd.CatID
                                          AND cd.CatDeID = p.CatDeID
                                          AND c.CatID = ?`, ID)))[0][0].ProCount;
        if (check)
            return null;
        await knex('categories_detail').where('CatID', ID).del();
        return knex('categories').where('CatID', ID).del();
    },
    findByCatID(ID) {
        return knex('categories').where('CatID', ID);
    },
    async saveEdit(obj) {
        const ID = obj.CatID;
        delete obj.CatID;
        return knex('categories').where('CatID', ID).update(obj);
    },
    async add(obj) {
        return knex('categories').insert(obj);
    }
}