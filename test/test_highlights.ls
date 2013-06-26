/*
global describe, it
*/
"use strict"

should = require("chai").should()
expandMetadata = require '../lib/expandMetadata.js'
grunt = require 'grunt'


#
# NB 'it' is a reserved word in livescript, meaning an unspecified parameter,
# so passing (_) from describe to allow it to be overridden.
#
describe "Metadata", (_)->

  var metadata
  var expanded
  var estations

  before ->
    metadata := grunt.file.readYAML 'test/fixtures/input.yaml'
    expanded := expandMetadata grunt, metadata
    estations := expanded.sources.stations

  describe "reading inputs.yaml", (_) ->
    it "should yield sources and stations", ->
      metadata.should.have.property('sources')
      (grunt.util._.size metadata.sources.stations).should.equal(6)

  describe "expanded metadata", (_) ->
    it "should have sources and stations", ->
      expanded.should.have.property('sources')
      (grunt.util._.size metadata.sources.stations).should.equal(6)

  describe "A1", (_) ->
    it "should have dependent A2", ->
      estations.A1.meta.dependents.should.include('A2')

  describe "A1", (_) ->
    it "should have no dependencies", ->
      should.not.exist(estations.A1.meta.dependencies)

  describe "A1", (_) ->
    it "should have highlight G2_RT2", ->
      estations.A1.meta.highlights.G2_RT2.should.equal 'RT2'

    it "should have highlight G2_RT3", ->
      estations.A1.meta.highlights.G2_RT3.should.equal 'RT3'




