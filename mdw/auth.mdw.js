export default function auth(req, res, next) {
    if (req.session.isLogin === false) {
        req.session.retUrl = req.originalUrl;
        return res.redirect('/account/login');
    }
    next();
}