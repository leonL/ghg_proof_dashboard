var Util = function() {

  function ceilTens(n) {
    return(Math.ceil(n/10) * 10);
  };

  function nextTens(n) {
    var next = ceilTens(n);
    if (next === n) {
      next = n + 10;
    }
    return(next);
  };

  function floorTens(n) {
    return(Math.floor(n/10) * 10);
  }

  function previousTens(n) {
    var previous = floorTens(n);
    if (previous === n) {
      previous = n - 10;
    }
    return(previous);
  };

  return {
    ceilTens: ceilTens,
    nextTens: nextTens,
    floorTens: floorTens,
    previousTens: previousTens
  };

}();
