# Use the EPICS base image
FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-20"
USER  root
ENV   EPICS="/opt/epics-base"
ENV   SYNAPPS="${EPICS}/synApps/support"
ENV   SIMDET_BIN="${EPICS}/synApps/support/areaDetector-R3-7/ADSimDetector/iocs/simDetectorIOC/bin/linux-x86_64"
ENV   PATH="${SIMDET_BIN}:${PATH}"
ENV   IOC_PREFIX="6iddSIM1:"
ENV   IOCNAME="default"
EXPOSE 5064 5065

RUN apt update  -y && apt upgrade -y && \
    apt install -y procps \
    && rm -rf /var/lib/apt/lists/*

# make the sim motor binary
WORKDIR /opt/epics-base/synApps/support/xxx-R6-1/iocBoot/iocxxx/
RUN     sed -i s/xxx:/'$(IOC_PREFIX)'/g common.iocsh
RUN     cp examples/motors.iocsh ./
RUN     cp examples/std.iocsh    ./
RUN     cp ${SYNAPPS}/motor-R7-1/modules/motorMotorSim/iocsh/motorSim.iocsh                 ${SYNAPPS}/motor-R7-1/iocsh/
RUN     cp ${SYNAPPS}/motor-R7-1/modules/motorMotorSim/iocsh/EXAMPLE_motorSim.substitutions ${SYNAPPS}/motor-R7-1/iocsh/
RUN     sed -i s_'#iocshLoad("$(STD)/iocsh/softScaler'_'iocshLoad("$(STD)/iocsh/softScaler'_g std.iocsh
RUN     sed -i s_'#iocshLoad("$(MOTOR)/iocsh/motorSim.iocsh"'_'iocshLoad("$(MOTOR)/iocsh/motorSim.iocsh"'_g motors.iocsh
RUN     sed -i s_'dbLoadTemplate("substitutions/motor.substitutions"'_'#dbLoadTemplate("substitutions/motor.substitutions"'_g motors.iocsh
RUN     sed -i sz'IOC=xxx'z'IOC=$(IOCNAME)'zg st.cmd.Linux
RUN     sed -i sz'< common.iocsh'z'< common.iocsh\n< std.iocsh\n< motors.iocsh'zg st.cmd.Linux

# build the sim scalers and motors
WORKDIR /opt/epics-base/synApps/support/xxx-R6-1
RUN     make rebuild

WORKDIR /opt/epics-base/synApps/support/xxx-R6-1/iocBoot/iocxxx/softioc
ENTRYPOINT [ "./run"]

# --- DEV ---
# docker build -t kedokudo/virtualbeamline:ioc6iddsimmtr .    
# docker run -it --rm -e IOC_PREFIX='test1:' -e IOCNAME='test1'  --net=virtualbeam kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash                                                                     
#./xxx.sh start