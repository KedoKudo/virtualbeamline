#!/bin/bash

# start caRepeat
/opt/epics-base-R7.0.3/bin/linux-x86_64/caRepeater &

# start the sim in screen session bg
cd /opt/epics-base-R7.0.3/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector
screen -dm -S simdet -h 9999 ../../bin/linux-x86_64/simDetectorApp st.cmd
