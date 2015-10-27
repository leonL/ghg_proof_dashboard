var Util = {

  nextTens: function(n) {
    var next = Math.ceil(n/10) * 10;
    if (next === n) {
      next = n + 10;
    }
    return(next);
  },

  previousTens: function(n) {
    var previous = Math.floor(n/10) * 10;
    if (previous === n) {
      previous = n - 10;
    }
    return(previous);
  }

};
