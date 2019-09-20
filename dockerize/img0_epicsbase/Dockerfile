FROM  continuumio/miniconda3:latest
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-20"
USER  root
WORKDIR /home

# Install necessary libraries from offical repo
RUN apt update  -y && apt upgrade -y && \
    apt install -y  build-essential libreadline-dev

# Get the latest version of EPICS
ENV EPICS_HOST_ARCH linux-x86_64
WORKDIR /opt
RUN wget https://github.com/epics-base/epics-base/archive/R7.0.3.tar.gz
RUN tar xzf R7.0.3.tar.gz
RUN rm  R7.0.3.tar.gz
RUN ln -s epics-base-R7.0.3 epics
WORKDIR /opt/epics
RUN make -j4 CFLAGS="-fPIC" CXXFLAGS="-fPIC"
WORKDIR /home
