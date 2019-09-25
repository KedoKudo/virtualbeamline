# Use the EPICS base image
FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-20"
USER  root
ENV   EPICS="/opt/epics-base-R7.0.3"
ENV   SIMDET_BIN="${EPICS}/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/bin/linux-x86_64"
ENV   PATH="${SIMDET_BIN}:${PATH}"
EXPOSE 5064 5065

# make the sim detector binary
WORKDIR /opt/epics/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC
RUN     make

# start the sim detector
WORKDIR /bin
RUN     ["ln", "-s", "${SIMDET_BIN}/simDetectorApp", "simDetectorApp"]
WORKDIR /opt/epics/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector

ENTRYPOINT ["simDetectorApp", "st.cmd"]
