(function() {
  var emitter;

  emitter = require('../emitter');

  module.exports = function(id, constants) {
    return {
      run: function() {
        return setInterval(function() {
          return emitter.emit(id);
        }, constants.interval);
      }
    };
  };

}).call(this);
