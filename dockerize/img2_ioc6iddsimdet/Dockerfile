# Use the EPICS base image
FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-24"
USER  root
ENV   EPICS="/opt/epics-base"
ENV   SIMDET_BIN="${EPICS}/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/bin/linux-x86_64"
ENV   PATH="${SIMDET_BIN}:${PATH}"
ENV   IOC_PREFIX="6iddSIM1:"
EXPOSE 5064 5065

# make the sim detector binary
WORKDIR /opt/epics-base/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector
RUN     sed -i s/13SIM1:/'$(IOC_PREFIX)'/g st_base.cmd
WORKDIR /opt/epics-base/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC
RUN     make

WORKDIR /opt/epics-base/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector
ENTRYPOINT ["simDetectorApp", "st.cmd"]

# --- DEV ---
# docker build -t kedokudo/virtualbeamline:ioc6iddsimdet .
# docker run -it --rm -e IOC_PREFIX='6iddSIMDET1:'  --net=virtualbeam kedokudo/virtualbeamline:ioc6iddsimdet /bin/bash
# simDetectorAPP st.cmd