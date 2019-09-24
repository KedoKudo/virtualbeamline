# Use the EPICS base image
FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-20"
USER  root
EXPOSE 5064 5065

WORKDIR /opt/epics-base-R7.0.3/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector
RUN     make

ADD     start.sh /
ENTRYPOINT [ "/bin/bash", "/start.sh" ]
