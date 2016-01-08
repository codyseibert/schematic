(function() {
  var emitter;

  emitter = require('../emitter');

  module.exports = function(id, constants) {
    return {
      run: function() {
        return emitter.emit(id, constants);
      }
    };
  };

}).call(this);
