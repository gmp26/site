#/bin/bash
grunt clearance:3
grunt build
rsync -av dist/ cmep.maths.org:/usr/local/www/cmep/html/swanage
ssh cmep.maths.org chgrp -R cmep /usr/local/www/cmep/html/swanage
