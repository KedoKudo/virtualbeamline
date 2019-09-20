# Use the EPICS base image
FROM kedokudo/virtualbeamline:base
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-20"
USER  root

# Install necessary libraries from offical repo
# * need the x11 support
# * need the libusb (newer faster usb support)
RUN apt update  -y && apt upgrade -y && \
    apt install -y  re2c libx11-dev xorg-dev libusb-dev libusb-1.0-0-dev

ADD     assemble_synApps.sh /opt/epics
WORKDIR /opt/epics
RUN     ["bash", "assemble_synApps.sh"]
WORKDIR /opt/epics/synApps/support
RUN     make release
RUN     make
RUN     make install
