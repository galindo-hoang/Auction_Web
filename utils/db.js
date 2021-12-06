import knexjs from "knex";

export const ConnectInfor = {
    host : '127.0.0.1',
    port : 3306,
    user : 'root',
    password : '',
    database : 'auction'
};
const knex = knexjs({
    client: 'mysql2',
    connection: ConnectInfor,
    pool: { min: 0, max: 10 }
});

export default knex;