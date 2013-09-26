````
layout: resource
clearance: -1
title: Lodash Markup Documentation
keywords:
  - lodash
  - test
resourceType: RT3
stids1:
stids2:
pvids1:
pvids2:
priors:

````

<: grunt.log.writeln("Testing lodash widget library") :>

This is a top level paragraph.

<: grunt.log.write("  style(chalk)...") :>
<:= style(chalk) :>
This text looks like it's been written in chalk

<:= style() :>
<: grunt.log.ok() :>

<: grunt.log.write("  style(well)...") :>
<:= style(well) :>
This text sits within a bootstrap well. It can contain TeX inline $x^2+y^2=z^2$ but this only shows in latex:
\begin{equation}
\chi(G)=\left(1+o(1)\right)\frac{n}{2\log_{1/q}n}
\end{equation}

However old-school math delimeters work fine in both html and latex
$$
\chi(G)=\left(1+o(1)\right)\frac{n}{2\log_{1/q}n}
$$

<:= style() :>
<: grunt.log.ok() :>

1.  This is a standard markdown numbered list

2.  Which has two elements.

    The second of which has two paragraphs

<: grunt.log.write("  hintAnswer(hLabel, hint, aLabel, answer)...") :>
<:= hintAnswer('Hint 1', '#hint1', 'A possible response', '#answer1') :>

  <:= collapsed("hint1") :>
  This is text for the hint 1 reveal.
  <:= collapsed() :>

  <:= collapsed("answer1") :>
  And it's corresponding answer 1.
  <:= collapsed() :>
<: grunt.log.ok() :>