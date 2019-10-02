FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-24"
USER  root
ENV   EPICS="/opt/epics-base"
ENV   EPICS_BASE="/opt/epics-base"
ENV   EPICS_HOST_ARCH="linux-x86_64"
ENV   EPICSEXTENSIONS="$opt/extensions"
ENV   SIMDET_BIN="/opt/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/bin/linux-x86_64"
ENV   PATH="${SIMDET_BIN}:${PATH}"

RUN apt-get update  -y && apt-get upgrade -y && \
    apt-get install -y  unzip libjpeg-dev libmotif-dev xfonts-100dpi xfonts-75dpi libxpa-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN ln -s epics-base base
ADD https://github.com/epics-extensions/extensions/archive/master.zip .
RUN    unzip master.zip && \
    rm master.zip && \
    mv extensions-master extensions

WORKDIR /opt/extensions/src
ADD https://github.com/epics-extensions/medm/archive/master.zip  .
RUN     unzip master.zip \
    &&  rm master.zip \
    &&  mv medm-master medm

WORKDIR /opt/extensions/lib/${EPICS_HOST_ARCH}
RUN  ln -s /usr/lib/x86_64-linux-gnu/libxcb.a . &&\
     ln -s /usr/lib/x86_64-linux-gnu/libXt.a .  &&\
     ln -s /usr/lib/x86_64-linux-gnu/libXm.a .  &&\
     ln -s /usr/lib/x86_64-linux-gnu/libXmu.a . &&\
     ln -s /usr/lib/x86_64-linux-gnu/libX11.a . &&\
     ln -s /usr/lib/x86_64-linux-gnu/libXext.a . 

# WORKDIR /opt/extensions
# remove Xp, not needed anymore
# ENV CFILE=/opt/extensions
# RUN ls -l ${CFILE}
RUN sed -i s:"Xm Xt Xp Xmu X11 Xext":"Xm Xt Xmu X11 Xext xcb":g                             /opt/extensions/src/medm/medm/Makefile  && \
    sed -i s:"#X11_LIB=/usr/lib/x86_64-linux-gnu":"X11_LIB=/usr/lib/x86_64-linux-gnu":g /opt/extensions/configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64 &&\ 
    sed -i s:"#X11_INC=/usr/include/X11":"X11_INC=/usr/include/X11":g                   /opt/extensions/configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64 &&\ 
    sed -i s:"#MOTIF_LIB=/usr/lib":"MOTIF_LIB=/usr/lib":g                               /opt/extensions/configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64 &&\ 
    sed -i s:"#MOTIF_INC=/usr/include":"MOTIF_INC=/usr/include":g                       /opt/extensions/configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64
    # sed -i s:"#USR_LDFLAGS += -pg":"USR_LDFLAGS += -lxcb":g                            /opt/extensions/src/medm/medm/Makefile

# RUN make 
# RUN make clean

# --- DEV --- 
# docker build -t kedokudo/virtualbeamline:medm .
# docker run -it --rm  kedokudo/virtualbeamline:medm /bin/bash
