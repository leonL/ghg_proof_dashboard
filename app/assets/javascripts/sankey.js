function createSankeyPlot($context) {

  var $form = $context.find('form');

  $form.on('ajax:success', function(e, data, status, xhr) {

    $('svg').empty();

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
    });
}