# Use the EPICS base image
FROM kedokudo/virtualbeamline:epics-base
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-25"
USER  root

# Install necessary libraries from offical repo
# * need the x11 support
# * need the libusb (newer faster usb support)
RUN apt update  -y && apt upgrade -y && \
    apt install -y  git re2c libx11-dev xorg-dev libusb-dev libusb-1.0-0-dev screen xvfb x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

ADD https://raw.githubusercontent.com/EPICS-synApps/support/master/assemble_synApps.sh  /opt/epics-base
WORKDIR /opt/epics-base
RUN sed -i sz'EPICS_BASE=/APSshare/epics/base-3.15.6'z'EPICS_BASE=/opt/epics-base/'zg assemble_synApps.sh
RUN ["bash", "assemble_synApps.sh"]
WORKDIR /opt/epics-base/synApps/support
RUN     make release
RUN     make
RUN     make install
