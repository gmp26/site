

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
        placement: "top",
        html:true
      }).click(function(e){
        $("svg [id^='node']").not($(this)).popover('hide');
        $(this).popover('toggle');
        MathJax.Hub.Queue(["Typeset",MathJax.Hub, $(".popover-content").get()]);
        e.stopPropagation();
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