#/bin/bash
rsync -av dist/ pan.maths.org:/usr/local/www/cmep/html/fenman
ssh cmep.maths.org chgrp -R cmep /usr/local/www/cmep/html/fenman