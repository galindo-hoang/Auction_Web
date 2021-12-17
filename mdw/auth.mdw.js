const auth = {
    beforeLogin: function (req, res, next){
        if (req.session.isLogin === false) {
            req.session.retUrl = req.originalUrl;
            return res.redirect('/account/login');
        }
        next();
    },
    afterLogin: function (req, res, next){
        if (req.session.isLogin === true) {
            return res.redirect('/');
        }
        next();
    },
    isSeller: function (req,res,next){
        if(+req.session.account.UserRole !== 1){
            return res.redirect('/account/profile');
        }
        next();
    }
}
export default auth