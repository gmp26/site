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
describe "Testing isolate task", (_it) ->

  before ->
    grunt.log.ok "isolate test"

  describe "token", (_it) ->
    it "should be saved", ->
      token = grunt.file.read ".isolate"
      token.should.equal "(EQ1)|(G2)"
