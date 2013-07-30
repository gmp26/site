"use strict"

module.exports = 

  #
  # Data to pass to lodash templates in pass2
  #
  data:
    hint_group: (hLabel, hint, aLabel, answer) ->"""
<div class='btn-group hint'>
<button type='button' class='btn btn-primary btn-action' data-toggle='collapse' data-target='#{hint}'>
#{hLabel}
</button>
<button type='button' class='btn btn-action' data-toggle='collapse' data-target='#{answer}'>
#{aLabel}
</button>
</div>
""".replace '\n',''

    divReveal_: (id) -> "<div id=\"#{id}\" class=\"collapse\">"
    _div: '</div>'   
