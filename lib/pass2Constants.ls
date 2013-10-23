module.exports = 
  #
  # returns an object that will extend the options.data used in pass2 templates in both
  # pass2UtilsHtml and pass2UtilsTex
  #

  # declare constants to avoid needing quotes
  chalk: 0
  well: 1
  left: 2
  right: 3
  twoColumn: 4

  # button types
  default: ""
  primary: "btn-primary"
  info: "btn-info"
  warning: "btn-warning"
  danger: "btn-danger"
  success: "btn-success"
  inverse: "btn-inverse"
  link: "btn-link"



  #
  # A stack used by style(X) to determine the correct translation for style().
  # Using a stack instead of a simple variable in case we see a need for nested styles
  # later.
  #
  endStack: []
  mathenv: ""

