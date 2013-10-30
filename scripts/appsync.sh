#!/bin/bash

RSITE=$1
RPATH=$2

rsync -av dist/ $RSITE:$RPATH
ssh $RSITE chgrp -R cmep $RPATH
ssh $RSITE chmod -R g+rwX $RPATH
