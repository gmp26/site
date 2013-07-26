(function(){
  "use strict";
  module.exports = function(grunt, sources, partialsDir){
    var getResourcePartData;
    getResourcePartData = require('./getFilePartData.js')(grunt, sources, partialsDir, 'resources');
    return function(resourceName, files, indexMeta){
      var _, sidebarOf;
      _ = grunt.util._;
      sidebarOf = function(indexMeta){
        var rv, stids1, pvids1, priors, laters;
        rv = null;
        stids1 = indexMeta.stids1;
        if (_.isArray(stids1) && stids1.length > 0) {
          rv == null && (rv = {});
          rv.stMetas = _.sortBy(_.map(stids1, function(id){
            return sources.stations[id].meta;
          }), function(it){
            return it.weight;
          });
        }
        pvids1 = indexMeta.pvids1;
        if (_.isArray(pvids1) && pvids1.length > 0) {
          rv == null && (rv = {});
          rv.pvMetas = _.map(pvids1, function(id){
            return sources.pervasiveIdeas[id].meta;
          });
        }
        priors = indexMeta.priors;
        if (_.isArray(priors) && priors.length > 0) {
          rv == null && (rv = {});
          rv.priorMetas = _.sortBy(_.map(priors, function(priorId){
            var prMeta;
            prMeta = sources.resources[priorId].index.meta;
            return {
              id: priorId,
              rtMeta: sources.resourceTypes[prMeta.resourceType].meta
            };
          }), function(pMeta){
            return pMeta.rtMeta.weight;
          });
        }
        laters = indexMeta.laters;
        if (_.isArray(laters) && laters.length > 0) {
          rv == null && (rv = {});
          rv.laterMetas = _.sortBy(_.map(laters, function(laterId){
            var lrMeta;
            lrMeta = sources.resources[laterId].index.meta;
            return {
              id: laterId,
              rtMeta: sources.resourceTypes[lrMeta.resourceType].meta
            };
          }), function(lMeta){
            return lMeta.rtMeta.weight;
          });
        }
        return rv;
      };
      return {
        sidebar: sidebarOf(indexMeta),
        parts: getResourcePartData(resourceName, files, indexMeta)
      };
    };
  };
}).call(this);
