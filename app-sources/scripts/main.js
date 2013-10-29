$(document).ready(function() {

  //
  // Create a small jQuery plugin that binds bootstrap popovers to elements
  // and renders any maths they may contain
  //
  $.fn.bindPopover = function (placement) {
    this.on('show', function() {
      // the timeout is necessary, but I'm not sure why.
      $(this).mathTimer = window.setTimeout(function() {
        console.log('showing');
        MathJax.Hub.Queue(["Typeset",MathJax.Hub], $('.popover-content').get());
      }, 0);
    }).on('hide', function() {
      // This is necessary to avoid MathJAX attempting to render a recently destroyed popover.
      // Test on C15, alternating hover over C14 and A9.
      var tid = $(this).mathTimer
      if(tid !== null) window.clearTimeout(tid);
    }).popover({
      trigger: "hover",
      container: "body",
      delay: {show:400, hide:200},
      placement: placement
    });
  }

  /* bind popovers to station buttons */
  $(".dependency").bindPopover("right");
  $(".dependent").bindPopover(document.documentElement.clientWidth < 765 ? "left" : "right");


});
