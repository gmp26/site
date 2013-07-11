/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing lesscss generation", function(_it){
    var metadata, expanded, lines;
    before(function(){
      metadata = grunt.config.get("metadata");
      return lines = metadata.sources.lines;
    });
    return describe("line metadata", function(_it){
      it("should provide colours for each line", function(){
        return _.each(lines, function(line){
          var meta;
          meta = line.meta;
          return meta.should.have.property('colour');
        });
      });
      it("should generate app/styles/lineVars.less", function(){
        return grunt.file.exists('app/styles/lineVars.less').should.be['true'];
      });
      it("should contain a as many lines as there are tube lines", function(){
        var css, lineCount;
        css = grunt.file.read("app/styles/lineVars.less");
        lineCount = css.split(/\S\n\S/).length;
        return lineCount.should.equal(_.size(lines));
      });
      return it("should contain correct line colours", function(){
        var css, cssLines;
        css = grunt.file.read("app/styles/lineVars.less");
        cssLines = css.split(/\n/);
        return _.each(cssLines, function(s){
          var m, lid, col, ref$;
          m = s.match(/@line([A-Z]{1,2}): (#[0-9a-fA-F]+);/);
          if (m !== null) {
            m.length.should.equal(3);
            lid = m[1];
            col = m[2];
            return col.should.equal((ref$ = lines[lid]) != null ? ref$.meta.colour : void 8);
          }
        });
      });
    });
  });
}).call(this);
