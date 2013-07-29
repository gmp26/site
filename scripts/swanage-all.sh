#/bin/bash
cd ~/CMEP/CMEP-site
grunt clearance:3
grunt build
rsync -av dist/ cmep.maths.org:/usr/local/www/cmep/html/swanage
