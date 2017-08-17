exports.applyRecord = function() {
  return function(io) {
    return function(i) {
      var result = {};
      Object.keys(io).forEach(function(k) {
        result[k] = io[k](i[k]);
      });
      return result;
    }
  }
}
