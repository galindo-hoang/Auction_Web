import express  from 'express';
import Users from './models/user.js';
import bcrypt from 'bcryptjs';
import local_mdw from "./mdw/local.mdw.js";
import view_mdw from "./mdw/view.mdw.js";

const app = express();

app.use('/public', express.static('public'));
// to get data from user (app.post)
app.use(express.urlencoded({extended:true}));

local_mdw(app);
view_mdw(app);

app.get('/',async (req, res) => {
    res.render('home');
})

app.get('/views',(req,res)=>{
    res.render('product/index');
})

app.get('/detail',(req,res)=>{
    res.render('product/detail');
})

app.get("/register", (req,res)=>{
    res.render('account/register');
})

app.post("/register", (req,res)=>{
    var salt = bcrypt.genSaltSync(10);
    const password = bcrypt.hashSync(req.body.password, salt);
    const object = {
        username: req.body.username,
        password: password,
        email: "",
        name: "a",
        admin: false,
        seller: false
    }
    Users.addUser(object);
    res.redirect('/login');
});

app.get("/register/check",async (req, res) => {
    const data = await Users.findByUserName(req.query.username);
    if(data.length === 0) res.json(true);
    else res.json(false);
});

app.get("/login",(req,res)=>{
    res.render('account/login');
});

app.post("/login",async (req, res) => {
    req.session.isAuth = (await Users.findByUserName(req.body.username))[0].id;
    console.log(req.session.isAuth + "login");
    res.redirect('/');
});

app.get('/login/check',async (req, res) => {
    const data = await Users.findByUserName(req.query.username);
    if (data.length === 0) res.json(false);
    else return res.json(bcrypt.compareSync(req.query.password,data[0].password));
});

app.get("/signout",(req,res)=>{
    req.session.destroy(function (err) {
        res.redirect("/");
    })
});

app.listen(300,()=>{
    console.log(`Example app listening at http://localhost:${300}`);
})