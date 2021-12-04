import express  from 'express';
import Users from './models/user.js';
import bcrypt from 'bcryptjs';
import local_mdw from "./mdw/local.mdw.js";
import view_mdw from "./mdw/view.mdw.js";
import register_route from "./routes/register.js";

const app = express();

app.use('/public', express.static('public'));
// to get data from user (app.post)
app.use(express.urlencoded({extended:true}));

local_mdw(app);
view_mdw(app);
app.use('/',register_route);


app.get('/',async (req, res) => {
    res.render('home');
})

app.get('/views',(req,res)=>{
    res.render('product/index');
})

app.get('/detail',(req,res)=>{
    res.render('product/detail');
})


app.get("/account/login",(req,res)=>{
    res.render('account/login');
});

app.post("/account/login",async (req, res) => {
    req.session.isAuth = (await Users.findByEmail(req.body.email))[0].id;
    res.redirect('/');
});

app.get('/account/login/check',async (req, res) => {
    const data = await Users.findByEmail(req.query.email);
    if (data.length === 0) res.json(false);
    else return res.json(bcrypt.compareSync(req.query.password,data[0].password));
});

app.get("/account/signOut",(req,res)=>{
    req.session.destroy(function (err) {
        res.redirect("/");
    })
});

app.get("/account/profile",async (req, res) => {
    const data = await Users.findByID(req.session.isAuth);
    res.render("account/profile", {user: data});
})

app.get("/account/review",(req,res)=>{
    res.render("account/review");
})

app.get("/account/tracking",(req,res)=>{
    res.render("account/tracking");
})

app.get("/account/favorite",(req,res)=>{
    res.render("account/favorite");
})

app.get("/account/purchased",(req,res)=>{
    res.render("account/purchase");
})

app.listen(300,()=>{
    console.log(`Example app listening at http://localhost:${300}`);
})