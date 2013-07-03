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
    describe("A1", function(_){
      return it("should not have highlighted G2_RT7", function(){
        var ref$;
        return should.not.exist((ref$ = estations.A1.meta.highlights) != null ? ref$.G2_RT7 : void 8);
      });
    });
    describe("A1", function(_){
      return it("should not have highlighted G2_RT2", function(){
        var ref$;
        return should.not.exist((ref$ = estations.A1.meta.highlights) != null ? ref$.G2_RT2 : void 8);
      });
    });
    describe("G2", function(_){
      return it("should have highlighted G2_RT7", function(){
        var ref$;
        return should.exist((ref$ = estations.G2.meta.highlights) != null ? ref$.G2_RT7 : void 8);
      });
    });
    return describe("NA3", function(_){
      return it("should have highlighted G2_RT2", function(){
        var ref$;
        return should.exist((ref$ = estations.NA3.meta.highlights) != null ? ref$.G2_RT2 : void 8);
      });
    });
  });
}).call(this);
