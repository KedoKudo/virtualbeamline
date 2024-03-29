# Use the EPICS base image
FROM kedokudo/virtualbeamline:epics-base
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-10-09"
USER  root


# --- System Configure ---
# Install necessary libraries from offical repo
# * need the x11 support
# * need the libusb (newer faster usb support)
# * xvfb for remote GUI viewing
RUN apt-get update  -y && \
    apt-get upgrade -y && \
    apt-get install -y    \
        git \
        libusb-1.0-0-dev \
        libusb-dev \
        libx11-dev \
        re2c \
        screen \
        xorg-dev \
        x11-xserver-utils \
        xvfb \
        && \
    rm -rf /var/lib/apt/lists/*
# ENV
# ENV APP_ROOT="/opt"
# ENV EPICS_HOST_ARCH=linux-x86_64
# ENV EPICS_ROOT="${APP_ROOT}/base"
# ENV EPICS_VERSION="7.0.3"
# ENV PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"
ENV SUPPORT="${APP_ROOT}/synApps/support"
ENV PATH="${PATH}:${SUPPORT}/utils"

# --- Install Synapp ---
WORKDIR ${APP_ROOT}
ADD https://raw.githubusercontent.com/EPICS-synApps/support/master/assemble_synApps.sh  ./

# -- NOTE:
# Thanks to @prjamien work
# The AREA_DETECTOR building in the building script is broken, therefore a
# two-stage building is necessary to get a functional synapp system
RUN sed -i sz'EPICS_BASE=/APSshare/epics/base-3.15.6'z'EPICS_BASE=${EPICS_ROOT}'zg assemble_synApps.sh
# No need for building these for virtual_beamline@linux-x86_64
RUN sed -i s/'ALLENBRADLEY='/'#ALLENBRADLEY='/g         assemble_synApps.sh && \
    sed -i s:'AREA_DETECTOR=':'#AREA_DETECTOR=':g       assemble_synApps.sh && \
    sed -i s/'CAMAC='/'#CAMAC='/g                       assemble_synApps.sh && \
    sed -i s/'DAC128V='/'#DAC128V='/g                   assemble_synApps.sh && \
    sed -i s/'DELAYGEN='/'#DELAYGEN='/g                 assemble_synApps.sh && \
    sed -i s/'DXP='/'#DXP='/g                           assemble_synApps.sh && \
    sed -i s/'DXPSITORO='/'#DXPSITORO='/g               assemble_synApps.sh && \
    sed -i s/'IP330='/'#IP330='/g                       assemble_synApps.sh && \
    sed -i s/'IPUNIDIG='/'#IPUNIDIG='/g                 assemble_synApps.sh && \
    sed -i s/'LOVE='/'#LOVE='/g                         assemble_synApps.sh && \
    sed -i s/'QUADEM='/'#QUADEM='/g                     assemble_synApps.sh && \
    sed -i s/'SOFTGLUE='/'#SOFTGLUE='/g                 assemble_synApps.sh && \
    sed -i s/'SOFTGLUEZYNQ='/'#SOFTGLUEZYNQ='/g         assemble_synApps.sh && \
    sed -i s/'VME='/'#VME='/g                           assemble_synApps.sh && \
    sed -i s/'YOKOGAWA_DAS='/'#YOKOGAWA_DAS='/g         assemble_synApps.sh

# prep synapps
RUN ["bash", "assemble_synApps.sh"]

# Build base synapps
WORKDIR ${SUPPORT}
RUN make -j2 all


# --- Motor&AD configure ---
ENV MOTOR=${SUPPORT}/motor-R7-1
ENV XXX=${SUPPORT}/xxx-R6-1

WORKDIR ${XXX}/iocBoot/iocxxx/
RUN cp examples/motors.iocsh ./ && \
    cp examples/std.iocsh    ./ && \
    cp ${MOTOR}/modules/motorMotorSim/iocsh/motorSim.iocsh                 ${MOTOR}/iocsh/ && \
    cp ${MOTOR}/modules/motorMotorSim/iocsh/EXAMPLE_motorSim.substitutions ${MOTOR}/iocsh/ && \
    sed -i s:'#iocshLoad("$(STD)/iocsh/softScaler':'iocshLoad("$(STD)/iocsh/softScaler':g std.iocsh && \
    sed -i s:'#iocshLoad("$(MOTOR)/iocsh/motorSim.iocsh"':'iocshLoad("$(MOTOR)/iocsh/motorSim.iocsh"':g motors.iocsh && \
    sed -i s:'dbLoadTemplate("substitutions/motor.substitutions"':'#dbLoadTemplate("substitutions/motor.substitutions"':g motors.iocsh && \
    # remove when https://github.com/epics-modules/xxx/pull/27 is merged and released in new synApps version
    sed -i s:'< common.iocsh':'< common.iocsh\n< std.iocsh\n< motors.iocsh':g st.cmd.Linux
RUN \
    sed -i s/'epicsEnvSet("PREFIX", "xxx:")'/'epicsEnvSet("PREFIX", $(PREFIX))'/g   ${XXX}/iocBoot/iocxxx/common.iocsh && \
    sed -i s:'IOC=xxx':'IOC=$(PREFIX)':g                                            ${XXX}/iocBoot/iocxxx/st.cmd.Linux
# fix for https://github.com/epics-modules/xxx/issues/30                                     
ADD https://github.com/prjemian/epics-docker/blob/master/n3_synApps/iocAdminSoft_aliases.db    ${XXX}/xxxApp/Db
ADD https://github.com/prjemian/epics-docker/blob/master/n3_synApps/iocAdminSoft_aliases.iocsh ${XXX}/iocBoot/iocxxx
# COPY iocAdminSoft_aliases.db ${XXX}/xxxApp/Db
# COPY iocAdminSoft_aliases.iocsh ${XXX}/iocBoot/iocxxx
RUN sed -i s+"IOC=\$(PREFIX)\")"+"IOC=\$(PREFIX)\")\n< iocAdminSoft_aliases.iocsh"+g ${XXX}/iocBoot/iocxxx/st.cmd.Linux

# Build ALL except area detector
WORKDIR ${SUPPORT}
RUN make -j4 all && make -C ${XXX}/iocBoot/iocxxx/ && make install
RUN ln -s ${XXX}/iocBoot/iocxxx/ ./iocxxx


# --- Manual install Area Detector --- 
ENV AREA_DETECTOR=${SUPPORT}/areaDetector-R3-7

# download components
ADD https://github.com/areaDetector/areaDetector/archive/R3-7.tar.gz ./areaDetector-R3-7.tar.gz
RUN \
    tar xzf areaDetector-R3-7.tar.gz && \
    /bin/rm areaDetector-R3-7.tar.gz && \
    echo "AREA_DETECTOR=\$(SUPPORT)/areaDetector-R3-7" >>  ${SUPPORT}/configure/RELEASE

WORKDIR ${AREA_DETECTOR}
ADD https://github.com/areaDetector/ADCore/archive/R3-7.tar.gz        ./ADCore.tar.gz
ADD https://github.com/areaDetector/ADSupport/archive/R1-9.tar.gz     ./ADSupport.tar.gz
ADD https://github.com/areaDetector/ADSimDetector/archive/R2-9.tar.gz ./ADSimDetector.tar.gz
ADD https://github.com/areaDetector/pvaDriver/archive/R1-5.tar.gz     ./pvaDriver.tar.gz
RUN \
    rmdir ADCore && \
    rmdir ADSupport && \
    rmdir ADSimDetector && \
    rmdir pvaDriver && \
    tar xzf ADCore.tar.gz && \
    tar xzf ADSupport.tar.gz && \
    tar xzf ADSimDetector.tar.gz && \
    tar xzf pvaDriver.tar.gz && \
    /bin/rm ADCore.tar.gz && \
    /bin/rm ADSupport.tar.gz && \
    /bin/rm ADSimDetector.tar.gz && \
    /bin/rm pvaDriver.tar.gz && \
    ln -s ADCore-R3-7 ADCore && \
    ln -s ADSupport-R1-9 ADSupport && \
    ln -s ADSimDetector-R2-9 ADSimDetector && \
    ln -s pvaDriver-R1-5 pvaDriver

# use example config file as a starting point
WORKDIR ${AREA_DETECTOR}/configure
RUN cp EXAMPLE_RELEASE.local                        RELEASE.local && \
    sed -i s:'#ADSIMDETECTOR=':'ADSIMDETECTOR=':g   RELEASE.local && \
    sed -i s:'#PVADRIVER=':'PVADRIVER=':g           RELEASE.local && \
    #
    cp EXAMPLE_RELEASE_LIBS.local                                                                 RELEASE_LIBS.local && \
    sed -i s:'areaDetector-3-7':'areaDetector-R3-7':g                                             RELEASE_LIBS.local && \
    sed -i s:'asyn-4-36':'asyn-R4-36':g                                                           RELEASE_LIBS.local && \
    sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.3':"EPICS_BASE=${EPICS_ROOT}":g RELEASE_LIBS.local && \
    #
    cp EXAMPLE_RELEASE_PRODS.local                                                                RELEASE_PRODS.local && \
    sed -i s:'areaDetector-3-7':'areaDetector-R3-7':g                                             RELEASE_PRODS.local && \
    sed -i s:'asyn-4-36':'asyn-R4-36':g                                                           RELEASE_PRODS.local && \
    sed -i s:'autosave-5-10':'autosave-R5-10':g                                                   RELEASE_PRODS.local && \
    sed -i s:'busy-1-7-2':'busy-R1-7-2':g                                                         RELEASE_PRODS.local && \
    sed -i s:'calc-3-7-3':'calc-R3-7-3':g                                                         RELEASE_PRODS.local && \
    sed -i s:'devIocStats-3-1-16':'iocStats-3-1-16':g                                             RELEASE_PRODS.local && \
    sed -i s:'seq-2-2-5':'seq-2-2-6':g                                                            RELEASE_PRODS.local && \
    sed -i s:'sscan-2-11-3':'sscan-R2-11-3':g                                                     RELEASE_PRODS.local && \
    sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.3':"EPICS_BASE=${EPICS_ROOT}":g RELEASE_PRODS.local && \
    #
    cp EXAMPLE_RELEASE_SUPPORT.local                                               RELEASE_SUPPORT.local && \
    sed -i s:'SUPPORT=/corvette/home/epics/devel':'SUPPORT=/opt/synApps/support':g RELEASE_SUPPORT.local && \
    #
    cp EXAMPLE_CONFIG_SITE.local     CONFIG_SITE.local.${EPICS_HOST_ARCH} && \
    # 
    sed -i s:'BUILD_IOCS = NO':'BUILD_IOCS = YES':g CONFIG_SITE.local.${EPICS_HOST_ARCH} && \
    sed -i s:'WITH_PVA = NO':'WITH_PVA = YES':g     CONFIG_SITE.local.${EPICS_HOST_ARCH} && \
    sed -i s:'WITH_QSRV = NO':'WITH_QSRV = YES':g   CONFIG_SITE.local.${EPICS_HOST_ARCH}

WORKDIR ${AREA_DETECTOR}/ADCore/iocBoot
RUN cp EXAMPLE_commonPlugins.cmd                                commonPlugins.cmd && \
    sed -i s:'#NDPvaConfigure':'NDPvaConfigure':g               commonPlugins.cmd && \
    sed -i s:'#dbLoadRecords("NDPva':'dbLoadRecords("NDPva':g   commonPlugins.cmd && \
    sed -i s:'#startPVAServer':'startPVAServer':g               commonPlugins.cmd && \
    #
    cp EXAMPLE_commonPlugin_settings.req                        commonPlugin_settings.req

WORKDIR ${SUPPORT}
ENV AD_PREFIX="13SIM1:"
RUN \
    ln -s ${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector ./iocSimDetector && \
    cp iocxxx/softioc/xxx.sh ./iocSimDetector/simDetector.sh && \
    # edit simDetector.sh
    sed -i s:'IOC_NAME=xxx':'IOC_NAME=simDetector':g                                              ./iocSimDetector/simDetector.sh && \
    sed -i s:'IOC_BINARY=xxx':'IOC_BINARY=simDetectorApp':g                                       ./iocSimDetector/simDetector.sh && \
    sed -i s:'IOC_STARTUP_DIR=/home/username/epics/ioc/synApps/xxx/iocBoot/iocxxx/softioc':'':g   ./iocSimDetector/simDetector.sh && \
    sed -i s:'IOC_STARTUP_DIR=`dirname ${SNAME}`/..':'IOC_STARTUP_DIR=`dirname ${SNAME}`':g       ./iocSimDetector/simDetector.sh && \
    sed -i s:'IOC_STARTUP_FILE="st.cmd.Linux"':'IOC_STARTUP_FILE="st.cmd"':g                      ./iocSimDetector/simDetector.sh && \
    # edit st_base.cmd
    sed -i s/'epicsEnvSet("PREFIX", "13SIM1:")'/'epicsEnvSet("PREFIX", \$\{AD_PREFIX})'/g   ./iocSimDetector/st_base.cmd && \
    echo "\ndbl > dbl-all.txt" >>                                                           ./iocSimDetector/st_base.cmd

WORKDIR ${SUPPORT}
RUN make release  && make install

# Build it all
WORKDIR ${AREA_DETECTOR}
RUN make -j4 all && make install

WORKDIR ${SUPPORT}

# --- Dev ---
# docker build -t kedokudo/virtualbeamline:synapp .
# docker run -it --rm kedokudo/virtualbeamline:synapp /bin/bash
