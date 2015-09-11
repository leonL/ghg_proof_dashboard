var scenarios, data;

$.ajax({
   type: "GET",
   contentType: "application/json; charset=utf-8",
   url: 'ghg_emission_totals/data',
   dataType: 'json',
   success: lineChart,
   error: function (result) {
       error();
   }
});

function lineChart(emissionsData) {

  data = emissionsData;

  var margin = {top: 20, right: 80, bottom: 30, left: 50},
      width = 960 - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;

  var svg = d3.select("svg#total-ghg-emissions")
              .attr("width", width + margin.left + margin.right)
              .attr("height", height + margin.top + margin.bottom)
              .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  scenarios = svg.selectAll(".scenario")
                      .data(emissionsData)
                      .enter().append("g")
                      .attr("class", "scenario");

  scenarios.append("path")
        .attr("class", "line")
        .attr("d", function(d) { console.log(d); });
}
