(function() {
  module.exports = function(id, constants) {
    return {
      run: function(input) {
        var fs;
        fs = require('fs');
        return fs.readFile(input.file, 'utf-8', function(err, data) {
          return console.log(data);
        });
      }
    };
  };

}).call(this);
