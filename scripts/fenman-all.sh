#/bin/bash
cd ~/CMEP/CMEP-site
grunt clearance:0
grunt build
rsync -av dist/ cmep.maths.org:/usr/local/www/cmep/html/fenman
