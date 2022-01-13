import {engine} from "express-handlebars";
import hbs_sections from "express-handlebars-sections";
import numeral from 'numeral';
import moment from "moment";

export default function (app){
    app.engine('hbs',engine({
        defaultLayout:'main',
        extname: 'hbs',
        helpers:{
            format_number(val) {
                return numeral(val).format('0,0');
            },
            section: hbs_sections(),
            format_date(date){
                return moment(date).format("DD/MM/YYYY, h:mm:ss A");
            },
            birth_date(date){
                return moment(date).format("YYYY-MM-DD");
            },
            format_rating(rating){
                return (parseFloat(rating)).toFixed(2)*100;
            }
        }
    }));
    app.set('view engine','hbs');
    app.set('views',"./views");
}