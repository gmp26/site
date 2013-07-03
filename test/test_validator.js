/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt;
  should = require("chai").should();
  grunt = require('grunt');
  describe("Testing validator", function(_){
    var metadata, sources, lines, stations, resources, resourceTypes, pervasiveIdeas;
    before(function(){
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      lines = sources.lines;
      stations = sources.stations;
      resources = sources.resources;
      resourceTypes = sources.resourceTypes;
      return pervasiveIdeas = sources.pervasiveIdeas;
    });
    describe("checking lines", function(_){
      return it("should delete bad lines", function(){
        return should.not.exist(lines["bad-lineName"]);
      });
    });
    describe("checking stations", function(_){
      return it("should delete bad stations", function(){
        should.not.exist(stations["BAD"]);
        should.not.exist(stations["BAD2"]);
        return should.not.exist(stations["BAD10"]);
      });
    });
    describe("checking pervasiveIdeas", function(_){
      return it("should delete bad pervasiveIdeas", function(){
        should.not.exist(pervasiveIdeas["bad-pvMissingTitle"]);
        return should.exist(pervasiveIdeas["bad-pvMissingFamily"]);
      });
    });
    describe("checking resources", function(_){
      return it("should delete bad resources, but not ones with missing refs", function(){
        should.not.exist(resources["bad-NotInFolder"]);
        should.not.exist(resources["bad-missingRT"]);
        return should.exist(resources["bad-missingRefs"]);
      });
    });
    return describe("resource missing refs should be deleted", function(_){
      return it("should delete missing refs from resources", function(){
        var mr;
        mr = resources["bad-missingRefs"].index.meta;
        mr.stids1.indexOf("G99").should.equal(-1);
        mr.stids2.indexOf("G100").should.equal(-1);
        mr.pvids1.indexOf("PI99").should.equal(-1);
        return mr.pvids2.indexOf("PI100").should.equal(-1);
      });
    });
  });
}).call(this);
