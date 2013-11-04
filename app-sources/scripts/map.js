

$(document).ready(function() {
  // Handler for .ready() called.

  /* kick MathJax to render the opened accordion element */
  $(".accordion-body").each(function(index, element) {
    $(element).on('shown', function() {
      console.log('showing'+index);
      MathJax.Hub.Queue(["Typeset",MathJax.Hub, element]);
    })
  });

  /* load fallback image if necessary */
  function supportsSVG() {
    // Grabbed from Modernizr
    return !!document.createElementNS && !!document.createElementNS('http://www.w3.org/2000/svg', "svg").createSVGRect;
  }
  if (!supportsSVG()) {
    $("#map").html('<img src="<%= pngUrl %>">');
  }
  else {
    /* twitter bootstrap popovers */
    $("svg [id^='node']").each(function(){
      id = $(this).attr("station-id");
      $(this).popover({
        title: popoverData[String(id)].title,
        content: popoverData[String(id)].content,
        container:"body",
        trigger: "manual",
        placement: function(context, source) {
          var position = $(source).position();
          if (position.top < 120)
            return "bottom";
          return "top";
        },
        html:true
      }).click(function(e){
        $("svg [id^='node']").not($(this)).popover('hide');
        $(this).popover('toggle');
        MathJax.Hub.Queue(["Typeset",MathJax.Hub, $(".popover-content").get()]);
        e.stopPropagation();
      }).hover(function(e){
        /* mouseenter event */
        id = $(this).attr("station-id");
        relevantStationIds = findRelevantStationIds(id);
        console.log(relevantStationIds);
        relevantEdges = $.grep($("svg .edge"), function(elem, index) {
          /* does this edge connect two relevant stations */
          foundOneRelevantStationEnd = false;
          for (i = 0; i < relevantStationIds.length; i++) {
            edgeEnds = $(elem).attr('id').split("_");
            if (_.contains(edgeEnds, relevantStationIds[i])) {
              if (foundOneRelevantStationEnd) 
                return true;
              foundOneRelevantStationEnd = true;
            }
          }
          return false;
        });
        relevantStations = $.grep($("svg [id^='node']"), function(elem, index) {
          /* does this station have a relevant station-id */
          for (i = 0; i < relevantStationIds.length; i++) {
            if ($(elem).attr('station-id') == relevantStationIds[i]) {
              return true;
            }
          }
          return false;
        });
        $("svg .edge").not(relevantEdges).fadeTo('fast',0.5);
        $("svg [id^='node']").not(relevantStations).fadeTo('fast',0.5);
      }, function(e){
        /* mouseout event */
        $("svg .edge").fadeTo('fast',1.0);
        $("svg [id^='node']").fadeTo('fast',1.0);
      });
    });
    $(document).click(function(e) {
      /* close popover on click outside */
      if (!$(e.target).is("svg [id^='node']") && $(e.target).closest(".popover").length == 0) {
          $("svg [id^='node']").popover('hide');
      }
    });
  }

});

function findRelevantStationIds(id) {
  // find relevant station ids recursively
  dependencies = findAllDependencies(id);
  dependents = findAllDependents(id);
  return _.union(dependencies, dependents);
}

function findAllDependencies(id) {
  if (typeof popoverData[String(id)] === 'undefined') {
    // deal with stations that are joined
    var stationIds = Object.keys(popoverData);
    // redefine id
    id = _.filter(stationIds, function(s){
      return s.indexOf(id + "-") > -1 || s.indexOf("-" + id) > -1;
    })[0];
  }
  console.log("Station " + id);
  var dependencies = popoverData[String(id)].dependencies;
  console.log(dependencies);
  var recursiveDependencies = dependencies;
  for (var i = 0; i < dependencies.length; i++) {
    if (id.indexOf(dependencies[i]) > -1) {
      // ignore circular dependencies
      continue;
    }
    try {
      recursiveDependencies = _.union(recursiveDependencies,findAllDependencies(dependencies[i]));
    }
    catch(ex) {
      // hit the recursion limit
      console.log("Error " + ex);
    }
  }
  return _.union(dependencies, recursiveDependencies, id);
}

function findAllDependents(id) {
  return [];
}

