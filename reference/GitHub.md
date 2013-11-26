Managing Forked copies of CMEP-sources
======================================

The [GitHub help docs](https://help.github.com/) go through git and github setup in a sensible and easy to follow fashion.

Start with the BootCamp and read on. It helps you setup git itself, configure your email and userid, and sort out your OSX credentials so that `git push` and `git pull` don't barf.

Also, scroll down to *Managing Remotes* to read how to connect remotes - e.g. to update your sources from CMEPorg/CMEP-sources.
The git docs on this have some helpful diagrams - but do start at the top rather than attempting to pick it up half way through.
That's all in http://git-scm.com/book/en/Git-Branching-Remote-Branches


Example 1 - setting up so you can update your fork from CMEPorg.
------

Let's say your fork is at https://github.com/rgt24/CMEP-sources.git, and you have a local directory
`CMEP-sources` connected to it by `git clone https://github.com/rgt24/CMEP-sources.git`.

The site copy is at `https://github.com/CMEPorg/CMEP-sources.git`. 

### Add CMEPorg as a remote
First time only
`$ git remote add CMEPorg https://github.com/CMEPorg/CMEP-sources.git`

The new remote is visible with `git remote -v`

### Fetch it from GitHub
First time only
```
$ git fetch CMEPorg

From https://github.com/CMEPorg/CMEP-sources
 * [new branch]      master     -> CMEPorg/master
```

### Checkout the remote into a tracking branch called 'site'
First time only
```
$ git checkout -b site CMEPorg/master

Branch site set up to track remote branch master from CMEPorg.
Switched to a new branch 'site'
```

This step creates the tracking branch `site` which is visible on `git config -l`. You won't need to create this branch again. 

Example 2 - pulling subsequent updates from CMEPorg 
------
On subsequent updates, you simply switch to the site branch and pull the update.
```
$ git checkout site
$ git pull

```

Example 3 - merging the update with your personal master
------

### Pull the site copy
```
$ git checkout site
$ git pull
```

### Switch back to your own master and merge
```
$ git checkout master
$ git merge
$ git commit -am'updated from site copy'
```

### Resolving any merge conflict
This usually works fine, but if there are any files that have been edited in both the site copy and your local master copy there may be merge conflict that need to be resolved manually. Fortunately there is a good tool to do this
```
$ git mergetool
```

Use the up-down keys to navigate through the conflicts, selecting the version you want to keep with the left-right keys. When you are finished save and quit. Git will repeat this process until all the merge conflicts have been resolved. Once done, commit your merged copy.
```
$ git commit -am'updated from site copy'
``` 

Example 4 - committing edits and pushing back to your fork
------
```
$ git add .
$ git commit -am'updated from site copy'
$ git push
```

Example 5 - updating your local copy from your fork
------
```
$ git pull

```
Again, if someone else has been editing your fork, there may be merge conflicts that you have to manage manually.


