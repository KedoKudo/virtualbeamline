FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-10-09"
USER  root

# ENV   EPICS_ROOT="${APP_ROOT}"
# ENV   EPICS="${EPICS_ROOT}"
ENV   EPICS_BASE="${APP_ROOT}/base"
ENV   EPICSEXTENSIONS="${APP_ROOT}/extensions"
ENV   EPICSLIB="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}"
ENV   EPICSINCLUDE="${EPICS_BASE}/include"
ENV   PYTHONVERSION="2.7"
ENV   PYTHONINCLUDE="/usr/include/python2.7"
ENV   PYTHONLIB="/usr/lib"
ENV   SIMDET_BIN="${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/bin/${EPICS_HOST_ARCH}"
ENV   QWTLIB="/usr/lib"
ENV   PATH="${SIMDET_BIN}:${PATH}"
ENV   CAQTDMVER="V4.2.4"

RUN apt-get update  -y && apt-get upgrade -y && \
    apt-get install -y  \
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
RUN     ["./caQtDM_BuildAll"]

# post-build config
ENV CAQTDM_DIR="/opt/caqtdm-4.2.4/"
ENV PATH="${CAQTDM_DIR}/caQtDM_Binaries:${PATH}"
ENV CAQTDM_DISPLAY_PATH="${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector"
ENV CAQTDM_OPTIMIZE_EPICS3CONNECTIONS="TRUE"
# ENV QT_PLUGIN_PATH="/usr/local/epics/extensions/lib/linux-x86_64"


# --- DEV --- 
# docker build -t kedokudo/virtualbeamline:caQTDM .
# docker run -it --rm  kedokudo/virtualbeamline:caQTDM /bin/bash

# --- GET GUI ---
# ifconfig en0
# 130.202.62.166 is the local IP assigned to your mac, for linux OS :0 is sufficient
# docker run -it --net=host -e DISPLAY=130.202.62.166:0 --volume="$HOME/.Xauthority:/root/.Xauthority:rw" kedokudo/virtualbeamline:caQTDM /bin/bash

# --- Area Detector Control UI file lcoation
# /opt/synApps/support/areaDetector-R3-7/ADSimDetector/simDetectorApp/op/ui/autoconvert
# running:  caQtDM -macro "P=6iddSim:,R=cam1:" simDetector.ui