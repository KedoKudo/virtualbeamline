FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-24"
USER  root
ENV   EPICS_ROOT="/opt"
ENV   EPICS="/opt/epics-base"
ENV   EPICS_BASE="/opt/epics-base"
ENV   EPICS_HOST_ARCH="linux-x86_64"
ENV   EPICSEXTENSIONS="${EPICS_ROOT}/extensions"
ENV   EPICSLIB="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}"
ENV   EPICSINCLUDE="${EPICS_BASE}/include"
ENV   PYTHONVERSION="2.7"
ENV   PYTHONINCLUDE="/usr/include/python2.7"
ENV   PYTHONLIB="/usr/lib"
ENV   SIMDET_BIN="/opt/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/bin/${EPICS_HOST_ARCH}"
ENV   QWTLIB="/usr/lib"
ENV   PATH="${SIMDET_BIN}:${PATH}"
ENV   CAQTDMVER="V4.2.4"

RUN apt update  -y && apt upgrade -y && \
    apt install -y  \
    libqwt-qt5-dev \
    libqt5svg5* \
    libqt5x11extras5* \
    python-dev \
    qt5-default \
    qttools5-dev \
    qttools5-dev-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/lib
RUN ln -s libqwt-qt5.so libqwt.so

WORKDIR /opt
ADD https://github.com/caqtdm/caqtdm/archive/${CAQTDMVER}.tar.gz  /opt
RUN    tar xvf ${CAQTDMVER}.tar.gz \
    && rm ${CAQTDMVER}.tar.gz \
    && ln -s caqtdm-4.2.4 caqtdm
WORKDIR /opt/caqtdm
# RUN     ["./caQtDM_BuildAll"]

# --- DEV --- 
# docker build -t kedokudo/virtualbeamline:caQTDM .
# docker run -it --rm  kedokudo/virtualbeamline:caQTDM /bin/bash
