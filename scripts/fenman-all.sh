#/bin/bash
grunt clearance:0
grunt build
rsync -av dist/ cmep.maths.org:/usr/local/www/cmep/html/fenman
ssh cmep.maths.org chgrp -R cmep /usr/local/www/cmep/html/fenman
