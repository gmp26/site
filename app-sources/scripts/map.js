

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
        // TODO | recurse over dependencies/dependents?
        dependencies = popoverData[String(id)].dependencies;
        dependents = popoverData[String(id)].dependents;
        relevantStationIds = dependencies.concat(dependents);
        relevantStationIds.push(String(id));
        relevantEdges = $.grep($("svg .edge"), function(elem, index) {
          /* does this edge connect to a relevant station? */
          for (i = 0; i < relevantStationIds.length; i++) {
            if ($(elem).attr('id').indexOf(relevantStationIds[i]) > -1) 
              return true;
          }
          return false;
        });
        relevantStations = $.grep($("svg [id^='node']"), function(elem, index) {
          /* does this station have the right station-id */
          for (i = 0; i < relevantStationIds.length; i++) {
            if ($(elem).attr('station-id').indexOf(relevantStationIds[i]) > -1) 
              return true;
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