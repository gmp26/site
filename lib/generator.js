(function(){
  "use strict";
  module.exports = function(grunt){
    var resourceLayout;
    function generateResource(sources, folder, resourceName, filename, meta){
      var layout, _head, _nav, _foot, common, view, html;
      layout = getLayout(sources, folder, meta);
      grunt.log.debug("  layout = " + layout);
      if (resourceLayout == null) {
        grunt.log.debug("Compiling resource layout");
        _head = grunt.file.read("sources/layouts/_head.html");
        _nav = grunt.file.read("sources/layouts/_nav.html");
        _foot = grunt.file.read("sources/layouts/_foot.html");
        common = grunt.template.process(grunt.file.read(layout), {
          data: {
            head: _head,
            nav: _nav,
            foot: _foot,
            view: '<%= view %>'
          }
        });
        grunt.log.debug(common);
        resourceLayout = grunt.util._.template(common);
      }
      view = grunt.file.read("partials/resources/" + resourceName + "/index.html");
      debugger;
      html = resourceLayout({
        path: resourceName,
        view: view
      });
      return grunt.file.write("app/" + resourceName + "/index.html", html);
    }
    function generateHTML(sources, folder, filename, meta){
      var layout;
      layout = getLayout(sources, folder, meta);
      return grunt.log.debug("  layout = " + layout);
    }
    function getLayout(sources, folder, meta){
      var prefix, postfix, layout;
      prefix = 'sources/layouts/';
      postfix = '.html';
      layout = meta.layout;
      if (layout && layout.length > 0) {
        return prefix + layout + postfix;
      }
      layout = folder;
      return prefix + layout + postfix;
    }
    return function(metadata){
      var sources, folder, items, resources, resourceName, files, index, fileName, meta, filename;
      grunt.log.debug("RUNNING");
      sources = metadata.sources;
      for (folder in sources) {
        items = sources[folder];
        grunt.log.debug("folder = <" + folder + ">");
        if (folder === 'resources') {
          resources = items;
          for (resourceName in resources) {
            files = resources[resourceName];
            grunt.log.debug("  resource = <" + resourceName + ">");
            index = files.index;
            fileName = 'index';
            meta = index.meta;
            generateResource(sources, folder, resourceName, fileName, meta);
          }
        } else {
          for (filename in items) {
            meta = items[filename];
            grunt.log.debug("  file = <" + filename + ">");
            generateHTML(sources, folder, filename, meta);
          }
        }
      }
      return 0;
    };
  };
}).call(this);
