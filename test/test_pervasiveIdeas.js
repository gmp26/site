/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing pervasive ideas expansion", function(_it){
    var metadata, pervasiveIdeas;
    before(function(){
      metadata = grunt.config.get("metadata");
      return pervasiveIdeas = metadata.sources.pervasiveIdeas;
    });
    describe("pervasiveIdeas", function(_it){
      return it("should have core properties", function(){
        return _.each(pervasiveIdeas, function(pi, id){
          pi.should.have.property('meta');
          pi.meta.should.have.property('id');
          pi.meta.should.have.property('family');
          return pi.meta.should.have.property('title');
        });
      });
    });
    return describe("pervasiveIdea PI1", function(_it){
      it("should list R1s", function(){
        var pi;
        pi = pervasiveIdeas.PI1.meta;
        pi.should.have.property('R1s');
        pi.R1s.length.should.equal(1);
        return pi.R1s[0].id.should.equal('PI1_RT15');
      });
      it("should list R2s", function(){
        var pi, ref$;
        pi = pervasiveIdeas.PI1.meta;
        pi.should.have.property('R2s');
        pi.R2s.length.should.equal(5);
        pi.R2s[0].id.should.equal('G2_RT2');
        return (ref$ = pi.R2s)[ref$.length - 1].id.should.equal('G2_RT7');
      });
      return it("should list stations from R1s and R2s", function(){
        var pi;
        pi = pervasiveIdeas.PI1.meta;
        pi.should.have.property('stids');
        return pi.stids.should.eql(['G2', 'G3']);
      });
    });
  });
}).call(this);