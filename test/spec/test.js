/*global describe, it */
'use strict';
(function () {

  describe('Give it some context', function() {
    describe('maybe a bit more context here', function() {
      it('should run here few assertions', function() {
        expect(3).to.equal(3);
        console.log("are you going crazy?");
      });
    });
    describe('maybe a bit more context here', function() {
      it('should run here few assertions', function() {
        expect(3).to.equal(3);
      });
    });
  });

  describe('Array', function(){
    describe('#indexOf()', function(){
      it('should return -1 when the value is not present', function(){
        expect([1,2,3].indexOf(5)).to.equal(-1);
        expect([1,2,3].indexOf(5)).to.equal(-1);
        expect([1,2,3].indexOf(1)).to.equal(0);
      })
    })
  })
})();
