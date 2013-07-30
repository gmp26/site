(function(){
  "use strict";
  module.exports = {
    data: {
      hint_group: function(hLabel, hint, aLabel, answer){
        return ("<div class='btn-group hint'>\n<button type='button' class='btn btn-primary btn-action' data-toggle='collapse' data-target='" + hint + "'>\n" + hLabel + "\n</button>\n<button type='button' class='btn btn-action' data-toggle='collapse' data-target='" + answer + "'>\n" + aLabel + "\n</button>\n</div>").replace('\n', '');
      },
      divReveal_: function(id){
        return "<div id=\"" + id + "\" class=\"collapse\">";
      },
      _div: '</div>'
    }
  };
}).call(this);
