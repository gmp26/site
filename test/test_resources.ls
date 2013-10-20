/*
global describe, it
*/
"use strict"

should = require("chai").should()
grunt = require 'grunt'
_ = grunt.util._

#
# NB 'it' is a reserved word in livescript, meaning an unspecified parameter,
# so passing (_it) from describe to allow 'it' to be overridden.
#
describe "Testing resourceType expansion", (_it)->

  var metadata
  var resourceTypes

  before ->
    metadata := grunt.config.get "metadata"
    resourceTypes := metadata.sources.resourceTypes

  describe "resourceTypes", (_it) ->
    it "should carry weights", ->
      _.each resourceTypes, (rt, id) ->
        rt.should.have.property 'meta'
        rt.meta.should.have.property 'weight'
        rt.meta.weight.should.be.a 'number'

describe "Testing resources expansion", (_it)->

  var metadata
  var expanded
  var resources
  var res
  var meta
  var pmeta
  var eq

  before ->
    metadata := grunt.config.get "metadata"
    resources := metadata.sources.resources
    res := resources.G2_RT2
    meta := resources.G2_RT3.index.meta
    pmeta := resources.G2_RT7.index.meta
    eq := resources.G2_RT13_EQ_0

  describe "good resources should exist", (_it) ->
    it "G2_RT2 should exist", ->
      should.exist resources.G2_RT2
    it "G2_RT3 should exist", ->
      should.exist resources.G2_RT3
    it "G2_RT7 should exist", ->
      should.exist resources.G2_RT7
    it "ok-missingLayout1 should exist", ->
      should.exist resources.["ok-missingLayout1"]
    it "ok-missingRefs should exist", ->
      should.exist resources.["ok-missingRefs"]
    it "ok-refPVmissingTitle should exist", ->
      should.exist resources.["ok-refPVmissingTitle"]
    it "PI1_RT15 should exist", ->
      should.exist resources.PI1_RT15
    it "PI1_RT4 should exist", ->
      should.exist resources.PI2_RT4

  describe "bad resources should not exist", (_it) ->
    it "bad-missingIndex should not exist", ->
      should.not.exist resources.["bad-missingIndex"]
    it "bad-missingRT should not exist", ->
      should.not.exist resources.["bad-missingRT"]
    it "bad-NotInFolder should not exist", ->
      should.not.exist resources.["bad-NotInFolder"]

  describe "G2_RT2 resource", (_it) ->

    it "index metadata should exist",  ->
      should.exist res.index.meta

    # solution exists, but solution.meta may be null
    it "solution should exist",  ->
      should.exist res.solution

  describe 'priors', (_it) ->
    it "should delete bad prior references", ->
      meta.priors.should.not.include 'missing' 
    it "should not delete good prior references", ->
      meta.priors.should.include 'G2_RT7' 
    it "should generate laters in prior", ->
      should.exist pmeta.laters
    it "should generate a later pointing back", ->
      pmeta.laters.should.include 'G2_RT3'
    it "should not repeat priors", ->
      (meta.priors.lastIndexOf('G2_RT7') - meta.priors.indexOf('G2_RT7'))
      .should.equal 0
    it "should not repeat laters", ->
      (pmeta.laters.lastIndexOf('G2_RT3') - pmeta.laters.indexOf('G2_RT3'))
      .should.equal 0

  describe 'titles are copied from index to solution', (_it) ->
    it "G2_RT7 solution should have a title", ->
      res = resources.G2_RT7
      res.solution.meta.title.should.equal "Woolly Mammoth"

  describe 'lastUpdated', (_it) ->
    it "should appear in resource metadata", ->
      should.exist meta.lastUpdated
      (meta.lastUpdated.match /\d\d-\d\d-\d\d/).should.not.be.null

  describe 'G2_RT13_EQ_0 review question', (_it) ->
    it "should not have lastUpdated metadata", ->
      should.exist eq?.index?.meta
      should.not.exist eq.index.meta.lastUpdated






 
 


