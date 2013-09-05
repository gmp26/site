/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing highlights expansion", function(_it){
    var metadata, expanded, estations;
    before(function(){
      metadata = grunt.config.get("metadata");
      return estations = metadata.sources.stations;
    });
    describe("checking metadata", function(_it){
      return it("should yield sources and stations", function(){
        metadata.should.have.property('sources');
        return _.size(metadata.sources.stations).should.equal(60);
      });
    });
    describe("A1", function(_it){
      return it("should have dependent A2", function(){
        return estations.A1.meta.dependents.should.include('A2');
      });
    });
    describe("A1", function(_it){
      return it("should have no dependencies", function(){
        estations.A1.meta.dependencies.should.be.a('array');
        return estations.A1.meta.dependencies.length.should.equal(0);
      });
    });
    describe("A1", function(_it){
      return it("should not have highlighted G2_RT7", function(){
        var ref$;
        return should.not.exist((ref$ = estations.A1.meta.highlights) != null ? ref$.G2_RT7 : void 8);
      });
    });
    describe("A1", function(_it){
      return it("should not have highlighted G2_RT2", function(){
        var ref$;
        return should.not.exist((ref$ = estations.A1.meta.R1s) != null ? ref$.G2_RT2 : void 8);
      });
    });
    describe("G2", function(_it){
      return it("should have highlighted G2_RT7", function(){
        return should.exist(_.find(estations.G2.meta.R1s, function(it){
          return it.id === "G2_RT7";
        }));
      });
    });
    return describe("NA3", function(_it){
      return it("should not have highlighted G2_RT2 since NA3 is not in stids1 for G2_RT2", function(){
        return should.not.exist(_.find(estations.NA3.meta.R1s, function(it){
          return it.id === "G2_RT2";
        }));
      });
    });
  });
}).call(this);
