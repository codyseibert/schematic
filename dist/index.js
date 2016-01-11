(function() {
  var Process, app, emitter, filewalker, init, log4js, logger, loggers, path, types;

  app = require("./" + process.argv[2] + "/nodes");

  emitter = require('./emitter');

  filewalker = require('filewalker');

  path = require('path');

  Process = require('./process');

  log4js = require('log4js');

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

  loggers = {};

  init = function() {
    var fn, id, node, nodes, processes, ref, results, type;
    processes = {};
    nodes = {};
    ref = app.nodes;
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
    results = [];
    for (id in nodes) {
      node = nodes[id];
      if (!!node.start) {
        logger.trace("starting " + id);
        results.push(processes[id].run([]));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

}).call(this);
