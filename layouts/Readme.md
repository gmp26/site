Layouts
=======

The layouts folder contains full page layouts, and layouts for 
partials that are to be inserted in the page.

Markdown pages may contain a `layout` attribute in metadata. If so, 
the html file by that name in this folder dictates the page layout.

If there is no `layout` attribute, then the folder containing the 
pages can locate it. A page in a folder called 'stations', will use
a layout called 'stations.html' if it exists.

If neither of these mechanisms succeeds, then 'default.html' is used.

Each layout contains HTML as it will appear in the final page. Mixed in are [template variables](http://gruntjs.com/api/grunt.template) that can be replaced by character strings during page generation.

Most variables have predefined meanings:

* `<%= content %>` will be replaced by the html compiled from markdown content.

Partial Layouts
---------------

Variables beginning with underscore `_` reference partial html files of the
same name in this directory

* `<%= _head %>` inserts the partial layout file '_head.html'
* `<%= _nav %>` inserts the partial layout file '_nav.html'
* `<%= _foot %>` inserts the partial layout file '_foot.html'

LoDash Delimiters
-----------------

Variables can be delimited by one of these LoDash delimiters:

* `<%= variable %>` Interpolate - replace variable with value.
* `<%- variable %>` Escape any HTML in the value when replacing the variable.
* `<% javascript %>` Evaluate the javascript. 
