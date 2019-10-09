# Use the EPICS base image
FROM kedokudo/virtualbeamline:synapp
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-10-09"
USER  root

# PV prefix
ENV   PREFIX="6iddSIM1:"
EXPOSE 5064 5065

RUN apt-get update  -y && apt-get upgrade -y && \
    apt-get install -y procps \
    && rm -rf /var/lib/apt/lists/*


# build the sim scalers and motors
WORKDIR /opt/synApps/support/xxx-R6-1
RUN     make rebuild

WORKDIR /opt/synApps/support/xxx-R6-1/iocBoot/iocxxx/softioc
ENTRYPOINT [ "./run"]

# --- DEV ---
# docker build -t kedokudo/virtualbeamline:ioc6iddsimmtr .    
# docker run -it --rm -e PREFIX='test1:' kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash                                                                     
#./xxx.sh start