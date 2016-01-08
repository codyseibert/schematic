(function() {
  var emitter;

  emitter = require('../emitter');

  module.exports = function(id, constants) {
    return {
      run: function() {
        var fs;
        fs = require('fs');
        return fs.watch(constants.file, function(event, filename) {
          console.log('emitting watcher');
          return emitter.emit(id, {
            file: constants.file
          });
        });
      }
    };
  };

}).call(this);
