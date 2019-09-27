FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-24"
USER  root
ENV   EPICS="/opt/epics-base"
ENV   EPICS_BASE="/opt/epics-base"
ENV   EPICSEXTENSIONS="${EPICS_BASE}/extensions"
ENV   SIMDET_BIN="/opt/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/bin/linux-x86_64"
ENV   PATH="${SIMDET_BIN}:${PATH}"

RUN apt update  -y && apt upgrade -y && \
    apt install -y  unzip libjpeg-dev libmotif-dev xfonts-100dpi xfonts-75dpi libxpa-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
ADD https://github.com/epics-extensions/medm/archive/master.zip /opt
RUN     unzip master.zip \
    &&  rm master.zip \
    &&  mkdir  ${EPICSEXTENSIONS} \
    &&  mkdir  ${EPICSEXTENSIONS}/src \
    &&  mv medm-master ${EPICSEXTENSIONS}/src \
    &&  mv ${EPICSEXTENSIONS}/src/medm-master ${EPICSEXTENSIONS}/src/medm
WORKDIR ${EPICS_BASE}
RUN make 
RUN make clean

# --- DEV --- 
# docker build -t kedokudo/virtualbeamline:medm .
# docker run -it --rm  kedokudo/virtualbeamline:medm /bin/bash
