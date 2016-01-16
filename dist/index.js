(function() {
  var Process, coffee, emitter, express, filewalker, fs, init, log4js, logger, multer, path, types, upload;

  emitter = require('./emitter');

  filewalker = require('filewalker');

  path = require('path');

  Process = require('./process');

  log4js = require('log4js');

  express = require('express');

  multer = require('multer');

  fs = require('fs');

  logger = require('morgan');

  coffee = require('coffee-script');

  upload = multer({
    dest: 'uploads'
  });

  logger = log4js.getLogger();

  types = {};

  filewalker('types').on('file', function(p, s) {
    var base;
    base = path.basename(p, '.js');
    logger.trace("Found process type: " + p);
    return types[base] = require("./types/" + base);
  }).on('done', function() {
    return init();
  }).walk();

  init = function() {
    var app;
    app = express();
    app.use(log4js.connectLogger(logger, {
      level: log4js.levels.TRACE
    }));
    app.get('/status', function(req, res) {
      res.status(200);
      return res.send('success');
    });
    app.post('/run', upload.single('file'), function(req, res, next) {
      var fn, id, loggers, node, nodes, nodesObject, processes, ref, script, type;
      logger.info(req.file);
      script = fs.readFileSync("" + req.file.path, 'utf-8');
      fs.writeFileSync(req.file.path + ".js", coffee.compile(script, 'utf-8'));
      fs.unlinkSync(req.file.path);
      processes = {};
      nodes = {};
      loggers = {};
      nodesObject = require("./" + req.file.path);
      ref = nodesObject.nodes;
      fn = function(id) {
        if (node.on != null) {
          logger.trace("  " + node.on + " -> " + id);
          return emitter.on(nodes[id].on, function(data) {
            logger.trace(nodes[id].on + " fired, calling " + id);
            return processes[id].run(data);
          });
        }
      };
      for (id in ref) {
        node = ref[id];
        logger.trace("Looping through node " + id + " with type " + node.type);
        logger.trace("  start: " + (!!node.start));
        logger.trace("  config: " + (JSON.stringify(node.config)));
        type = node.type;
        if (loggers[id] == null) {
          loggers[id] = log4js.getLogger(id);
        }
        if (!types[type]) {
          logger.error(type + " is an undefined type");
          continue;
        }
        nodes[id] = node;
        processes[id] = new Process(id, nodes[id].config, loggers[id], types[type]);
        fn(id);
      }
      for (id in nodes) {
        node = nodes[id];
        if (!!node.start) {
          logger.trace("starting " + id);
          processes[id].run([]);
        }
      }
      res.status(200);
      return res.send('running script');
    });
    return app.listen(10000);
  };

}).call(this);
