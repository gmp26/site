setTimeout(euclid, 1);

function euclid() {
  var width = 960,
      height = 600,
      x = d3.scale.linear(),
      colour = d3.scale.category20c(),
      duration = 0,
      min = 1,
      max = 200,
      spiral = true;

  var vis = d3.select("#vis").append("svg")
        .attr("width", width)
        .attr("height", height),
      svg = vis.append("g")
        .attr("transform", "translate(.5,.5)");
   
  d3.select("#update").on("click", click);
  d3.selectAll("#animate, #spiral").on("change", click);
  d3.select(window)
      .on("resize", resize);

  resize();

  function resize() {
    width = window.innerWidth;
    height = window.innerHeight - 120;
    click();
  }

  function redraw(p, q) {
    x.domain([0, p]).range([0, Math.min(p / q, width / height) * height - 2]);

    vis .attr("width", x(p) + 2)
        .attr("height", x(q) + 2);

    var r,
        rect = {x: 0, y: 0, dx: p, dy: q},
        iteration = 0,
        nodes = [];

    do {
      var i = Math.floor(p / q);
      r = p % q;
      var l = [];
      for (var c = 0; c < i; c++) {
        nodes.push({x: rect.x, y: rect.y, dx: q, dy: q, depth: iteration});
        if (spiral) {
          switch (iteration & 3) {
            case 0: rect.x += q; continue;
            case 1: rect.y += q; continue;
            case 2: rect.x -= q; continue;
            case 3: rect.y -= q; continue;
          }
        } else {
          rect[iteration & 1 ? "y" : "x"] += q;
        }
      }
      if (spiral) {
        switch (iteration & 3) {
          case 2: rect.y += q - r;
          case 1: rect.x += q - r; break;
          case 3: rect.y += q - r; break;
        }
      }
      p = q;
      q = r;
      iteration++;
    } while (r !== 0 && iteration < 200);

    if (duration) svg.selectAll("g").remove();

    var cell = svg.selectAll("g")
        .data(nodes, function(d, i) { return d.depth + "-" + i; });

    // Entering cells.
    var cellEnter = cell.enter().append("g")
        .attr("class", "cell");
    cellEnter.append("rect");

    // Exiting cells.
    cell.exit().remove();

    // Updating cells.
    var g = cell
        .attr("visibility", "hidden")
        .attr("transform", function(d) { return "translate(" + x(d.x) + "," + x(d.y) + ")"; });
    (duration ? g.transition().duration(0).delay(function(d, i) { return i * 200; }) : g)
        .attr("visibility", null);
    cell.select("rect")
        .attr("width", function(d) { return x(d.dx); })
        .attr("height", function(d) { return x(d.dy); })
        .style("stroke", "#333")
        .style("stroke-width", 1)
        .style("fill", function(d) { return colour(d.depth); });
  }

  function transition(g) {
    return duration ? g.transition().duration(duration) : g;
  }

  function click() {
    var p = clamp("#p"),
        q = clamp("#q");
    duration = d3.select("#animate").property("checked") ? 1000 : 0;
    spiral = d3.select("#spiral").property("checked");
    redraw(p, q);
  }

  function clamp(q) {
    var x = d3.select(q),
        value = Math.max(min, Math.min(max, ~~x.property("value")));
    x.property("value", value);
    d3.select(q + "-value").text(value);
    return value;
  }
}
