/*
global describe, it
*/
(function(){
  "use strict";
  var should, expandMetadata, grunt;
  should = require("chai").should();
  expandMetadata = require('../lib/expandMetadata.js');
  grunt = require('grunt');
  describe("Metadata", function(_){
    var metadata, expanded, estations;
    beforeEach(function(){
      metadata = grunt.file.readYAML('test/fixtures/input.yaml');
      expanded = expandMetadata(grunt, metadata);
      return estations = expanded.sources.stations;
    });
    describe("reading inputs.yaml", function(_){
      return it("should yield sources and stations", function(){
        metadata.should.have.property('sources');
        return grunt.util._.size(metadata.sources.stations).should.equal(6);
      });
    });
    describe("expanded metadata", function(_){
      return it("should have sources and stations", function(){
        expanded.should.have.property('sources');
        return grunt.util._.size(metadata.sources.stations).should.equal(6);
      });
    });
    describe("A1", function(_){
      return it("should have dependent A2", function(){
        return estations.A1.meta.dependents.should.include('A2');
      });
    });
    describe("A1", function(_){
      return it("should have no dependencies", function(){
        console.log(estations.A1.meta.dependencies);
        return should.not.exist(estations.A1.meta.dependencies);
      });
    });
    return describe("A1", function(_){
      it("should have highlight G2_RT2", function(){
        return estations.A1.meta.highlights.G2_RT2.should.equal('RT2');
      });
      return it("should have highlight G2_RT3", function(){
        return estations.A1.meta.highlights.G2_RT3.should.equal('RT3');
      });
    });
  });
}).call(this);
