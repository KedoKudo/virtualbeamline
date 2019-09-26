FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-24"
USER  root
ENV   EPICS="/opt/epics-base"
ENV   EPICS_BASE="/opt/epics-base"
ENV   EPICSEXTENSIONS="${EPICS_BASE}/extensions"
ENV   SIMDET_BIN="${EPICS}/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/bin/linux-x86_64"
ENV   PATH="${SIMDET_BIN}:${PATH}"
ENV   CAQTDMVER="V4.2.4"

RUN apt update  -y && apt upgrade -y && \
    apt install -y  qt5-default \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
ADD https://github.com/caqtdm/caqtdm/archive/${CAQTDMVER}.tar.gz  /opt
RUN    tar xvf ${CAQTDMVER}.tar.gz \
    && rm ${CAQTDMVER}.tar.gz \
    && ln -s caqtdm-4.2.4 caqtdm
WORKDIR /opt/caqtdm
RUN     ["./caQtDM_BuildAll"]

# --- DEV --- 
# docker build -t kedokudo/virtualbeamline:caQTDM .
# docker run -it --rm  kedokudo/virtualbeamline:caQTDM /bin/bash
