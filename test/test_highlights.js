/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt;
  should = require("chai").should();
  grunt = require('grunt');
  describe("Testing highlights expansion", function(_){
    var metadata, expanded, estations;
    before(function(){
      metadata = grunt.config.get("metadata");
      return estations = metadata.sources.stations;
    });
    describe("checking metadata", function(_){
      return it("should yield sources and stations", function(){
        metadata.should.have.property('sources');
        return grunt.util._.size(metadata.sources.stations).should.equal(60);
      });
    });
    describe("A1", function(_){
      return it("should have dependent A2", function(){
        return estations.A1.meta.dependents.should.include('A2');
      });
    });
    describe("A1", function(_){
      return it("should have no dependencies", function(){
        return should.not.exist(estations.A1.meta.dependencies);
      });
    });
    return describe("A1", function(_){
      return it("should not have highlight G2_RT7", function(){
        var ref$;
        console.log((ref$ = estations.A1.meta.highlights) != null ? ref$.G2_RT7 : void 8);
        return should.not.exist((ref$ = estations.A1.meta.highlights) != null ? ref$.G2_RT7 : void 8);
      });
    });
  });
}).call(this);
