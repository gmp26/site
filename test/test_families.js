/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing pervasiveIdea family expansion", function(_it){
    var metadata;
    before(function(){
      return metadata = grunt.config.get("metadata");
    });
    return describe("families", function(_it){
      it("should be a non empty array", function(){
        metadata.should.have.property('families');
        return metadata.families.should.be['instanceof'](Array);
      });
      it("should contain 2 families", function(){
        return metadata.families.length.should.equal(2);
      });
      return it("should contain a concept and a process in order", function(){
        metadata.families[0].family.should.equal('concept');
        metadata.families[0].pvids.length.should.equal(2);
        metadata.families[1].family.should.equal('process');
        return metadata.families[1].pvids.length.should.equal(4);
      });
    });
  });
}).call(this);
