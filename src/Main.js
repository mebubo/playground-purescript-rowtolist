exports.applyRecord = function(io) {
  return function(i) {
    var result = {};
    Object.keys(io).each(function(k) {
      result[k] = io[k](i[k]);
    });
    return result;
  }
}
