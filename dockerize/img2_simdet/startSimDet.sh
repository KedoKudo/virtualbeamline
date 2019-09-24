#!/bin/bash

# start caRepeat
caRepeater &

#screen -dm -S simdet -h 9999 ../../bin/linux-x86_64/simDetectorApp st.cmd
simDetectorApp st.cmd
