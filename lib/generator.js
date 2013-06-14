(function(){
  "use strict";
  module.exports = function(grunt){
    function generateResource(sources, folder, resourceName, filename, meta){
      var layout;
      layout = getLayout(sources, folder, meta);
      return grunt.log.debug("  layout = " + layout);
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
      var sources, folder, files, filename, meta, resourceName;
      grunt.log.debug("RUNNING");
      sources = metadata.sources;
      for (folder in sources) {
        files = sources[folder];
        grunt.log.debug("folder = <" + folder + ">");
        for (filename in files) {
          meta = files[filename];
          grunt.log.debug("  file = <" + filename + ">");
          if (folder === 'resources') {
            resourceName = filename;
            filename = 'index';
            meta = meta.meta;
            generateResource(sources, folder, resourceName, filename, meta);
          } else {
            generateHTML(sources, folder, filename, meta);
          }
        }
      }
      return 0;
    };
  };
}).call(this);
