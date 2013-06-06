How to create a resource for CMEP
=================================

CMEP resource sources are stored in a folder alongside any assets (images, interactives, etc.) that the resource needs. The resource itself should be written in a text editor using [Pandoc flavour markdown](http://johnmacfarlane.net/pandoc/README.html), or LaTeX with a minimalist set of packages. In either case, delimit mathematics notation with `$` for inline maths or `$$` for display maths.

If you submit a resource in LaTeX, we will use Pandoc to convert it to markdown, and thereafter maintain the markdown copy as authoritative. Authors may wish to [install Pandoc](http://johnmacfarlane.net/pandoc/installing.html) themselves to check that the result is good.

Check List
----------

- Decide on an identifier for the resource. This identifier will be used
to address the resource on the web so avoid characters that require special treatment by selecting from `[a-z]` or `[A-Z]` or `[0-9]` or the underscore character. Do not use spaces. Instead `join_words_together` with the underscore or by making a `CamelCaseIdentifier`.

- Make a folder for the resource, naming it with your chosen identifier.

- Choose a markup language to use - either [Pandoc](http://johnmacfarlane.net/pandoc/) or [LaTeX](http://latex-project.org/guides/).

- Create the main file for the resource, naming it `index.md` or `index.tex`. 

- Place any other asset files in the resource folder. Link to them from the main text using _relative_ links - i.e. by filename only, and not by pathname or full URI.

Multi-page resources
--------------------

We expect most resources to be published as a single _possibly quite long_ page rather to be than split arbitrarily into a multi-page form. Scrolling works well with all device formats.

If a resource naturally splits into more than one page, then second and subsequent pages may be created within the resource directory. Choose identifer names with .md or .tex suffix as appropriate.

The index page should then live up to its name and provide relative links to these other pages.

URL for publication
-------------------

Resources will be published at 
`http://cambridge.maths.org/resources/<resourceId>`.

Metadata
--------

Insert metadata in the (final) index.md file. [An example is here](index.md)

