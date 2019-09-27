# Use the EPICS base image
FROM kedokudo/virtualbeamline:epics-base
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-25"
USER  root


# Install necessary libraries from offical repo
# * need the x11 support
# * need the libusb (newer faster usb support)
# * xvfb for remote GUI viewing
RUN apt update  -y && apt upgrade -y && \
    apt install -y  \
    git \
    re2c \
    libx11-dev xorg-dev x11-xserver-utils\
    libusb-dev libusb-1.0-0-dev \
    screen xvfb \
    && \
    rm -rf /var/lib/apt/lists/*

ENV EPICS_HOST_ARCH=linux-x86_64
ENV EPICS_ROOT="/opt/epics-base"
ENV PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"
ENV SYNAPPS_PARENT="/opt"
ENV SUPPORT="${SYNAPPS_PARENT}/synApps/support"
ENV PATH="${PATH}:${SUPPORT}/utils"


WORKDIR ${SYNAPPS_PARENT}
ADD https://raw.githubusercontent.com/EPICS-synApps/support/master/assemble_synApps.sh  ${SYNAPPS_PARENT}

# Edit build script
RUN sed -i sz'EPICS_BASE=/APSshare/epics/base-3.15.6'z'EPICS_BASE=/opt/epics-base/'zg assemble_synApps.sh
# do NOT build these for linux-x86_64
RUN sed -i s/'ALLENBRADLEY='/'#ALLENBRADLEY='/g assemble_synApps.sh && \
    sed -i s/'CAMAC='/'#CAMAC='/g               assemble_synApps.sh && \
    sed -i s/'DAC128V='/'#DAC128V='/g           assemble_synApps.sh && \
    sed -i s/'DELAYGEN='/'#DELAYGEN='/g         assemble_synApps.sh && \
    sed -i s/'DXP='/'#DXP='/g                   assemble_synApps.sh && \
    sed -i s/'DXPSITORO='/'#DXPSITORO='/g       assemble_synApps.sh && \
    sed -i s/'IP330='/'#IP330='/g               assemble_synApps.sh && \
    sed -i s/'IPUNIDIG='/'#IPUNIDIG='/g         assemble_synApps.sh && \
    sed -i s/'LOVE='/'#LOVE='/g                 assemble_synApps.sh && \
    sed -i s/'QUADEM='/'#QUADEM='/g             assemble_synApps.sh && \
    sed -i s/'SOFTGLUE='/'#SOFTGLUE='/g         assemble_synApps.sh && \
    sed -i s/'SOFTGLUEZYNQ='/'#SOFTGLUEZYNQ='/g assemble_synApps.sh && \
    sed -i s/'VME='/'#VME='/g                   assemble_synApps.sh && \
    sed -i s/'YOKOGAWA_DAS='/'#YOKOGAWA_DAS='/g assemble_synApps.sh

# prep synapps
RUN ["bash", "assemble_synApps.sh"]

# recommended edits: https://areadetector.github.io/master/install_guide.html
WORKDIR ${SUPPORT}/areaDetector-R3-7/configure
RUN cp EXAMPLE_RELEASE.local         RELEASE.local && \
    cp EXAMPLE_RELEASE_SUPPORT.local RELEASE_SUPPORT.local && \
    cp EXAMPLE_RELEASE_LIBS.local    RELEASE_LIBS.local && \
    cp EXAMPLE_RELEASE_PRODS.local   RELEASE_PRODS.local && \
    cp EXAMPLE_CONFIG_SITE.local     CONFIG_SITE.local && \
    sed -i s:'#ADSIMDETECTOR=':'ADSIMDETECTOR=':g                                                         RELEASE.local && \
    # sed -i s:'#ADURL=':'ADURL=':g                                                                         RELEASE.local && \
    sed -i s:'#PVADRIVER=':'PVADRIVER=':g                                                                 RELEASE.local && \
    sed -i s:'asyn-4-36':'asyn-R4-36':g                                                              RELEASE_LIBS.local && \
    sed -i s:'areaDetector-3-7':'areaDetector-R3-7':g                                                RELEASE_LIBS.local && \
    sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.3':'EPICS_BASE=/opt/epics-base':g RELEASE_LIBS.local && \
    sed -i s:'asyn-4-36':'asyn-R4-36':g                                                             RELEASE_PRODS.local && \
    sed -i s:'areaDetector-3-7':'areaDetector-R3-7':g                                               RELEASE_PRODS.local && \
    sed -i s:'autosave-5-10':'autosave-R5-10':g                                                     RELEASE_PRODS.local && \
    sed -i s:'busy-1-7-2':'busy-R1-7-2':g                                                           RELEASE_PRODS.local && \
    sed -i s:'calc-3-7-3':'calc-R3-7-3':g                                                           RELEASE_PRODS.local && \
    sed -i s:'seq-2-2-5':'seq-2-2-6':g                                                              RELEASE_PRODS.local && \
    sed -i s:'sscan-2-11-3':'sscan-R2-11-3':g                                                       RELEASE_PRODS.local && \
    sed -i s:'devIocStats-3-1-16':'iocStats-3-1-16':g                                               RELEASE_PRODS.local && \
    sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.3':'EPICS_BASE=/opt/epics-base':g RELEASE_PRODS.local && \
    sed -i s:'SUPPORT=/corvette/home/epics/devel':'SUPPORT=/opt/synApps/support':g                RELEASE_SUPPORT.local

WORKDIR ${SUPPORT}/areaDetector-R3-7/ADCore/iocBoot
RUN cp EXAMPLE_commonPlugins.cmd           commonPlugins.cmd && \
    cp EXAMPLE_commonPlugin_settings.req   commonPlugin_settings.req && \
    sed -i s:'#NDPvaConfigure':'NDPvaConfigure':g             commonPlugins.cmd && \
    sed -i s:'#dbLoadRecords("NDPva':'dbLoadRecords("NDPva':g commonPlugins.cmd && \
    sed -i s:'#startPVAServer':'startPVAServer':g             commonPlugins.cmd

WORKDIR ${SUPPORT}
# archive the template IOC, for making new XXX IOCs
RUN tar czf ../../xxx-R6-1.tar.gz xxx-R6-1
RUN make -j2 all
RUN make clean


# --- Dev ---
# docker build -t kedokudo/virtualbeamline:synapp .
# docker run -it --rm kedokudo/virtualbeamline:synapp /bin/bash