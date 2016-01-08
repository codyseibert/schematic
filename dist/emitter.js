(function() {
  var emitter, events;

  events = require('events');

  emitter = new events.EventEmitter();

  module.exports = emitter;

}).call(this);
