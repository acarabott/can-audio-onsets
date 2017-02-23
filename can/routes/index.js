var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', {
    title: '50 ways to change a number',
    number: 666
  });
});

module.exports = router;
