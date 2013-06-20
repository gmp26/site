"use strict"

module.exports = (grunt) ->
  return (metadata) ->
    _ = grunt.util._
    output = ''
    prevlinecolour = ''
    i = 0
    postreplace = new Array()
    for stationname,data of metadata.stations
      linename = stationname.replace(/[0-9].*/g,'')
      linecolour = metadata.lines[linename].meta.colour
      for dep of data.meta.dependencies
        for dept of data.meta.dependents
          if data.meta.dependencies[dep] == data.meta.dependents[dept]
            ordered = _.sortBy([stationname,data.meta.dependents[dept]])
            replacement = '"'+ordered[0]+'-'+ordered[1]+'"'
            postreplace[i++] = {"stationname": stationname, "replacement": replacement}
            stationname = replacement;
            data.meta.dependents[dept] = ''

      for dept of data.meta.dependents
        if data.meta.dependents[dept] != ''
          if linecolour != prevlinecolour
            output = output+'edge [style=bold ,color="'+linecolour+'"]\n'
            prevlinecolour = linecolour
          output = output + stationname + ' -> ' + data.meta.dependents[dept] + ' ;\n'

    for next of postreplace
      reg = new RegExp(postreplace[next].stationname+' ','g')
      output = output.replace(reg,postreplace[next].replacement)

    output = 'digraph G {
    node [shape=plaintext ,fillcolor="#EEF2FF", fontsize=16, fontname=arial]' + output + '}'
    grunt.file.write('partials/tubemap.dot',output)

/*
    dot = '/opt/local/bin/dot'
    if grunt.file.exists dot
      options = {cmd:dot,args:['-Tsvg','-opartials/tubemap.svg','partials/tubemap.dot']}
      grunt.util.spawn options, (error, result, code) ->
        grunt.log.debug code
        if code != 0
         grunt.log.error(result.stderr)
    else
      grunt.log.debug "no dot installed at "+dot+" not building map"
*/

