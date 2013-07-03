/*
global describe, it
*/
"use strict"

should = require("chai").should()
grunt = require 'grunt'

#
# NB 'it' is a reserved word in livescript, meaning an unspecified parameter,
# so passing (_) from describe to allow it to be overridden.
#
describe "Testing highlights expansion", (_)->

  var metadata
  var expanded
  var estations

  before ->
    metadata := grunt.config.get "metadata"
    estations := metadata.sources.stations

  describe "checking metadata", (_) ->
    it "should yield sources and stations", ->
      metadata.should.have.property('sources')
      (grunt.util._.size metadata.sources.stations).should.equal 60

  describe "A1", (_) ->
    it "should have dependent A2", ->
      estations.A1.meta.dependents.should.include('A2')

  describe "A1", (_) ->
    it "should have no dependencies", ->
      should.not.exist(estations.A1.meta.dependencies)

  describe "A1", (_) ->
    it "should not have highlighted G2_RT7", ->
      should.not.exist(estations.A1.meta.highlights?.G2_RT7)

  describe "A1", (_) ->
    it "should not have highlighted G2_RT2", ->
      should.not.exist(estations.A1.meta.highlights?.G2_RT2)

  describe "G2", (_) ->
    it "should have highlighted G2_RT7", ->
      should.exist(estations.G2.meta.highlights?.G2_RT7)

  describe "NA3", (_) ->
    it "should have highlighted G2_RT2", ->
      should.exist(estations.NA3.meta.highlights?.G2_RT2)



