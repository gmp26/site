#/bin/bash
cd ~/CMEP/CMEP-site
rsync -av dist/ cmep.maths.org:/usr/local/www/cmep/html/swanage
