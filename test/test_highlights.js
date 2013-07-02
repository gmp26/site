/*
global describe, it
*/
(function(){
  "use strict";
  var should, expandMetadata, grunt;
  should = require("chai").should();
  expandMetadata = require('../lib/expandMetadata.js');
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
        return grunt.util._.size(metadata.sources.stations).should.equal(59);
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
      return it("should have highlight G2_RT2", function(){
        var ref$, ref1$;
        return (ref$ = estations.A1.meta.highlights) != null ? (ref1$ = ref$.G2_RT2) != null ? ref1$.should.equal('RT2') : void 8 : void 8;
      });
    });
  });
}).call(this);
