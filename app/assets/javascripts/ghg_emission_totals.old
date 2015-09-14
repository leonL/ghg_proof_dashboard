var scenarios, data;

// $.ajax({
//    type: "GET",
//    contentType: "application/json; charset=utf-8",
//    url: 'ghg_emission_totals/data',
//    dataType: 'json',
//    success: renderGhgEmissionsLineChart,
//    error: function (result) {
//        error();
//    }
// });

function renderGhgEmissionsLineChart(data) {
  // mock data for testing
  // data =
  //   [
  //     {scenario: 0, year: 2030, ghg_emissions: 20},
  //     {scenario: 0, year: 2015, ghg_emissions: 15},
  //     {scenario: 0, year: 2020, ghg_emissions: 20},
  //     {scenario: 1, year: 2020, ghg_emissions: 60},
  //     {scenario: 1, year: 2015, ghg_emissions: 30},
  //     {scenario: 1, year: 2030, ghg_emissions: 80}
  //   ];

  // function compare(a,b) {
  //   if (a.year < b.year)
  //     return -1;
  //   if (a.year > b.year)
  //     return 1;
  //   return 0;
  // }

  // data.sort(compare);

  var xMax = d3.max(data, function(datum) { return datum.year; }),
      xMin = d3.min(data, function(datum) { return datum.year; }),
      yMax = d3.max(data, function(datum) { return datum.ghg_emissions; }),
      yMin = d3.min(data, function(datum) { return datum.ghg_emissions; });

  emissionsData = d3.nest()
            .key(function(d) {return d.scenario;})
            .entries(data);

  var chart = lineChart()
          .x(d3.scale.linear().domain([xMin, xMax]))
          .y(d3.scale.linear().domain([yMin, yMax]));


  emissionsData.forEach(function (series) {
      chart.addSeries(series);
  });

  chart.render();
}

function lineChart() { // <-1A
    var _chart = {};

    var _width = 600, _height = 300, // <-1B
            _margins = {top: 30, left: 30, right: 30, bottom: 30},
            _x, _y,
            _data = [],
            _colors = d3.scale.category10(),
            _svg,
            _bodyG,
            _line;

    _chart.render = function () { // <-2A
        if (!_svg) {
            _svg = d3.select("body").append("svg") // <-2B
                    .attr("height", _height)
                    .attr("width", _width);

            renderAxes(_svg);

            defineBodyClip(_svg);
        }

        renderBody(_svg);
    };

    function renderAxes(svg) {
        var axesG = svg.append("g")
                .attr("class", "axes");

        renderXAxis(axesG);

        renderYAxis(axesG);
    }

    function renderXAxis(axesG){
        var xAxis = d3.svg.axis()
                .scale(_x.range([0, quadrantWidth()]))
                .orient("bottom");

        axesG.append("g")
                .attr("class", "x axis")
                .attr("transform", function () {
                    return "translate(" + xStart() + "," + yStart() + ")";
                })
                .call(xAxis);

        d3.selectAll("g.x g.tick")
            .append("line")
                .classed("grid-line", true)
                .attr("x1", 0)
                .attr("y1", 0)
                .attr("x2", 0)
                .attr("y2", - quadrantHeight());
    }

    function renderYAxis(axesG){
        var yAxis = d3.svg.axis()
                .scale(_y.range([quadrantHeight(), 0]))
                .orient("left");

        axesG.append("g")
                .attr("class", "y axis")
                .attr("transform", function () {
                    return "translate(" + xStart() + "," + yEnd() + ")";
                })
                .call(yAxis);

         d3.selectAll("g.y g.tick")
            .append("line")
                .classed("grid-line", true)
                .attr("x1", 0)
                .attr("y1", 0)
                .attr("x2", quadrantWidth())
                .attr("y2", 0);
    }

    function defineBodyClip(svg) { // <-2C
        var padding = 5;

        svg.append("defs")
                .append("clipPath")
                .attr("id", "body-clip")
                .append("rect")
                .attr("x", 0 - padding)
                .attr("y", 0)
                .attr("width", quadrantWidth() + 2 * padding)
                .attr("height", quadrantHeight());
    }

    function renderBody(svg) { // <-2D
        if (!_bodyG)
            _bodyG = svg.append("g")
                    .attr("class", "body")
                    .attr("transform", "translate("
                        + xStart() + ","
                        + yEnd() + ")") // <-2E
                    .attr("clip-path", "url(#body-clip)");

        renderLines();

        // renderDots();
    }

    function renderLines() {
        _line = d3.svg.line() //<-4A
                        .x(function (d) { return _x(d.year); })
                        .y(function (d) { return _y(d.ghg_emissions); });

        _bodyG.selectAll("path.line")
                    .data(_data)
                .enter() //<-4B
                .append("path")
                .attr("d", function (d) { return _line(d.values); })
                .style("stroke", function (d, i) {
                    return _colors(i); //<-4C
                })
                .style('fill', 'none')
                .attr("class", "line");

        // _bodyG.selectAll("path.line")
        //         .data(_data)
        //         .transition() //<-4D
        //         .attr("d", function (d) { return _line(d); });
    }

    function renderDots() {
        _data.forEach(function (list, i) {
            _bodyG.selectAll("circle._" + i) //<-4E
                        .data(list)
                    .enter()
                    .append("circle")
                    .attr("class", "dot _" + i);

            _bodyG.selectAll("circle._" + i)
                    .data(list)
                    .style("stroke", function (d) {
                        return _colors(i); //<-4F
                    })
                    .transition() //<-4G
                    .attr("cx", function (d) { return _x(d.x); })
                    .attr("cy", function (d) { return _y(d.y); })
                    .attr("r", 4.5);
        });
    }

    function xStart() {
        return _margins.left;
    }

    function yStart() {
        return _height - _margins.bottom;
    }

    function xEnd() {
        return _width - _margins.right;
    }

    function yEnd() {
        return _margins.top;
    }

    function quadrantWidth() {
        return _width - _margins.left - _margins.right;
    }

    function quadrantHeight() {
        return _height - _margins.top - _margins.bottom;
    }

    _chart.width = function (w) {
        if (!arguments.length) return _width;
        _width = w;
        return _chart;
    };

    _chart.height = function (h) { // <-1C
        if (!arguments.length) return _height;
        _height = h;
        return _chart;
    };

    _chart.margins = function (m) {
        if (!arguments.length) return _margins;
        _margins = m;
        return _chart;
    };

    _chart.colors = function (c) {
        if (!arguments.length) return _colors;
        _colors = c;
        return _chart;
    };

    _chart.x = function (x) {
        if (!arguments.length) return _x;
        _x = x;
        return _chart;
    };

    _chart.y = function (y) {
        if (!arguments.length) return _y;
        _y = y;
        return _chart;
    };

    _chart.addSeries = function (series) { // <-1D
        _data.push(series);
        return _chart;
    };

    return _chart; // <-1E
}

// function lineChart(emissionsData) {

//   var margin = {top: 20, right: 80, bottom: 30, left: 50},
//       width = 960 - margin.left - margin.right,
//       height = 500 - margin.top - margin.bottom;

//   var svg = d3.select("svg#total-ghg-emissions")
//               .attr("width", width + margin.left + margin.right)
//               .attr("height", height + margin.top + margin.bottom)
//               .append("g")
//               .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

//   var x = d3.time.scale()
//       .range([0, width]);

//   var y = d3.scale.linear()
//       .range([height, 0]);

//   var xAxis = d3.svg.axis()
//       .scale(x)
//       .orient("bottom");

//   var yAxis = d3.svg.axis()
//       .scale(y)
//       .orient("left");

//   var line = d3.svg.line()
//       .interpolate("basis")
//       .x(function(d) { return x(d.year); })
//       .y(function(d) { return y(d.total_emissions); });

//   x.domain(d3.extent(data, function(d) { return d.date; }));

//   y.domain([
//     d3.min(cities, function(c) { return d3.min(c.values, function(v) { return v.temperature; }); }),
//     d3.max(cities, function(c) { return d3.max(c.values, function(v) { return v.temperature; }); })
//   ]);

//   scenarios = svg.selectAll(".scenario")
//                       .data(data)
//                       .enter().append("g")
//                       .attr("class", "scenario");

//   scenarios.append("path")
//         .attr("class", "line")
//         .attr("d", function(d) { return line(d.values); })
//         .style("stroke", 'black');
// }
