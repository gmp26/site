#!/bin/bash
pandoc -s -t slidy -o ITMeeting2.html ITMeeting2.md
pandoc -o ITMeeting2.pdf ITMeeting2.md
