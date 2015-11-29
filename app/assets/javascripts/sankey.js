function createSankeyPlot($context) {

  var $form = $context.find('form');

  // Mock data layout for 'Fuel Type to Sector to Useful/Waste Energy' sankey
  var data = {
    "nodes": [
      {"name": "Natural Gas"},
      {"name": "Oil"},
      {"name": "Coal"},
      {"name": "Water"},
      {"name": "Solar"},
      {"name": "Wind"},
      {"name": "Other"},
      {"name": "Electricity"},
      {"name": "Residential"},
      {"name": "Commercial"},
      {"name": "Industry"},
      {"name": "Transportation"},
      {"name": "Useful Energy"},
      {"name": "Wasted Energy"}
    ],
    // value indicates petajoules of energy
    "links": [
      {"source": 0, "target": 7, "value": 300},
      {"source": 7, "target": 8, "value": 300},
      {"source": 0, "target": 7, "value": 100},
      {"source": 7, "target": 9, "value": 100},
      {"source": 0, "target": 10, "value": 42},
      {"source": 0, "target": 11, "value": 30},
      {"source": 1, "target": 8, "value": 300},
      {"source": 3, "target": 7, "value": 100},
      {"source": 7, "target": 8, "value": 100},
      {"source": 4, "target": 8, "value": 42},
      {"source": 6, "target": 8, "value": 30},
      {"source": 1, "target": 9, "value": 250},
      {"source": 2, "target": 7, "value": 100},
      {"source": 7, "target": 9, "value": 100},
      {"source": 3, "target": 9, "value": 50},
      {"source": 4, "target": 9, "value": 400},
      {"source": 5, "target": 9, "value": 100},
      {"source": 6, "target": 9, "value": 128},
      {"source": 1, "target": 10, "value": 600},
      {"source": 2, "target": 7, "value": 200},
      {"source": 7, "target": 10, "value": 200},
      {"source": 3, "target": 10, "value": 50},
      {"source": 5, "target": 10, "value": 350},
      {"source": 6, "target": 10, "value": 286},
      {"source": 1, "target": 11, "value": 200},
      {"source": 2, "target": 11, "value": 275},
      {"source": 3, "target": 7, "value": 225},
      {"source": 7, "target": 11, "value": 225},
      {"source": 5, "target": 11, "value": 46},
      {"source": 8, "target": 12, "value": 400},
      {"source": 8, "target": 13, "value": 72},
      {"source": 9, "target": 12, "value": 900},
      {"source": 9, "target": 13, "value": 28},
      {"source": 10, "target": 12, "value": 1400},
      {"source": 10, "target": 13, "value": 86},
      {"source": 11, "target": 12, "value": 500},
      {"source": 11, "target": 13, "value": 46}
    ]
  };

  var intensityRamp = d3.scale.linear().domain([0,d3.max(data.links, function(d) {return d.value})]).range(["black", "red"])

  var width = 900,
      height = 500;

  var sankey = d3.sankey()
    .nodeWidth(20)
    .nodePadding(50)
    .size([width, height]);

  var path = sankey.link();

  sankey
    .nodes(data.nodes)
    .links(data.links)
    .layout(200);

  function dragmove(d) {
    d3.select(this).attr("transform",
        "translate(" + (
             d.x = Math.max(0, Math.min(width - d.dx, d3.event.x))
          ) + "," + (
                   d.y = Math.max(0, Math.min(height - d.dy, d3.event.y))
            ) + ")");
    sankey.relayout();
    link.attr("d", path);
  }

  expData = data;

  d3.select("svg").append("g").attr("transform", "translate(20,20)").attr("id", "sankeyG");

  var link = d3.select("#sankeyG").selectAll(".link")
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
      .style("stroke", "gray");

  d3.selectAll(".node").append("text")
      .attr("x", 0)
      .attr("y", function(d) { return d.dy / 2; })
      .attr("text-anchor", "left")
      .text(function(d) { return d.name; });

  d3.selectAll('.node')
    .call(d3.behavior.drag()
    .origin(function(d) { return d; })
    .on("dragstart", function() {
      this.parentNode.appendChild(this); })
    .on("drag", dragmove));

  $form.on('ajax:success', function(e, data, status, xhr) {
    return null;
  });
}