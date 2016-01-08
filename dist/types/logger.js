(function() {
  var emitter;

  emitter = require('../emitter');

  module.exports = function(id, constants) {
    return {
      run: function(input) {
        return console.log(input);
      }
    };
  };

}).call(this);
