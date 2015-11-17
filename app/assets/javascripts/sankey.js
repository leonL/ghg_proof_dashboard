function createSankeyPlot() {

  // Mock data layout for 'Sector to GHG Emissions' sankey
  var sectorToEmissionsData = {
    "nodes": [
      {"name": "Residential"},
      {"name": "Commercial"},
      {"name": "Industry"},
      {"name": "Transportation"},
      {"name": "GHG Emissions"}
    ],
    // sourceVal indicates petajoules of energy
    // targetVal indicates megatonnes of CO2e
    "links": [
      {"source": 0, "target": 4, "sourceVal": 472, "targetVal": 11},
      {"source": 1, "target": 4, "sourceVal": 928, "targetVal": 29},
      {"source": 2, "target": 4, "sourceVal": 1486, "targetVal": 27},
      {"source": 3, "target": 4, "sourceVal": 546, "targetVal": 18}
    ]
  };
  // Mock data layout for 'Sector to Useful/Waste Energy' sankey
  var data = {
    "nodes": [
      {"name": "Residential"},
      {"name": "Commercial"},
      {"name": "Industry"},
      {"name": "Transportation"},
      {"name": "Useful Energy"},
      {"name": "Wasted Energy"}
    ],
    // value indicates petajoules of energy
    "links": [
      {"source": 0, "target": 4, "value": 400},
      {"source": 0, "target": 5, "value": 72},
      {"source": 1, "target": 4, "value": 900},
      {"source": 1, "target": 5, "value": 28},
      {"source": 2, "target": 4, "value": 1400},
      {"source": 2, "target": 5, "value": 86},
      {"source": 3, "target": 4, "value": 500},
      {"source": 3, "target": 5, "value": 46}
    ]
  };

  var intensityRamp = d3.scale.linear().domain([0,d3.max(data.links, function(d) {return d.value})]).range(["black", "red"])

  var sankey = d3.sankey()
    .nodeWidth(20)
    .nodePadding(50)
    .size([900, 500]);

  var path = sankey.link();

  sankey
      .nodes(data.nodes)
      .links(data.links)
      .layout(200);

  expData = data;

  d3.select("svg").append("g").attr("transform", "translate(20,20)").attr("id", "sankeyG");

  d3.select("#sankeyG").selectAll(".link")
      .data(data.links)
    .enter().append("path")
      .attr("class", "link")
      .attr("d", sankey.link())
      .style("stroke-width", function(d) {return d.dy})
      .style("stroke-opacity", .5)
      .style("fill", "none")
      .style("stroke", function(d){return intensityRamp(d.value)})
      .sort(function(a, b) { return b.dy - a.dy; })
      .on("mouseover", function() {d3.select(this).style("stroke-opacity", .8)})
      .on("mouseout", function() {d3.selectAll("path.link").style("stroke-opacity", .5)})

  d3.select("#sankeyG").selectAll(".node")
      .data(data.nodes)
    .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

  d3.selectAll(".node").append("rect")
      .attr("height", function(d) {  return d.dy; })
      .attr("width", 20)
      .style("fill", "pink")
      .style("stroke", "gray")

  d3.selectAll(".node").append("text")
      .attr("x", 0)
      .attr("y", function(d) { return d.dy / 2; })
      .attr("text-anchor", "left")
      .text(function(d) { return d.name; });
}