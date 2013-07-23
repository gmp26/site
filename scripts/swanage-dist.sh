#/bin/bash
cd ~/CMEP/CMEP-site
rsync -av dist/ gmp26@pan.maths.org:/usr/local/www/cmep/html/swanage
