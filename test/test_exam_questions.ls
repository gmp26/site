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
describe "Testing exam questions", (_it)->

  var metadata
  var meta
  var examQuestions
  var resources

  before ->
    metadata := grunt.config.get "metadata"
    examQuestions := metadata.sources.examQuestions
    resources := metadata.sources.resources
    meta := examQuestions.Q1.index.meta

  describe "ExamQuestions", (_it) ->
    it "should have lastUpdated metadata", ->
      should.exist meta.lastUpdated
      (meta.lastUpdated.match /\d\d \w\w\w \d\d\d\d/).should.not.be.null


