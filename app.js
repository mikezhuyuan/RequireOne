
/**
 * Module dependencies.
 */
require('coffee-script');
var analyze = require('./analyze');
var express = require('express');

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes
app.get('/', graph);
app.get('/graph', graph);
app.get('/result', result);

app.listen(3000, function(){
  console.log("Listening...");
});

//handlers
function graph(req, res){
  res.sendfile(__dirname + '/public/graph.html');
};

function result(req, res){
  var result = analyze('config.js');
  res.json(result);
};