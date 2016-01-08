(function() {
  var app, emitter, filewalker, init, path, types;

  app = require("./" + process.argv[2] + "/nodes.json");

  emitter = require('./emitter');

  filewalker = require('filewalker');

  path = require('path');

  types = {};

  filewalker('types').on('file', function(p, s) {
    var base;
    base = path.basename(p, '.js');
    return types[base] = require("./types/" + base);
  }).on('done', function() {
    return init();
  }).walk();

  init = function() {
    var id, node, nodes, ref, results, type, units;
    units = {};
    nodes = {};
    ref = app.nodes;
    for (id in ref) {
      node = ref[id];
      type = node.type;
      if (!types[type]) {
        console.log(type + " is an undefined type");
        continue;
      }
      nodes[id] = node;
      units[id] = types[type](id, node.constants);
      if (node.on != null) {
        (function(id, node) {
          return emitter.on(node.on, units[id].run);
        })(id, node);
      }
    }
    results = [];
    for (id in nodes) {
      node = nodes[id];
      if (!!node.start) {
        results.push(units[id].run());
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

}).call(this);
