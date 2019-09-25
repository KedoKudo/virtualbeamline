FROM  ubuntu:latest
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-20"
USER  root
WORKDIR /home

# Install necessary libraries from offical repo
RUN apt update  -y && \
    apt upgrade -y && \
    apt install -y  build-essential libreadline-dev wget

# Get the latest version of EPICS
ENV EPICS_ROOT="/opt/epics-base"
ENV EPICS_HOST_ARCH=linux-x86_64
ENV PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"

RUN echo EPICS_HOST_ARCH=${EPICS_HOST_ARCH}
RUN echo EPICS_ROOT=${EPICS_ROOT}
RUN echo PATH=${PATH}

WORKDIR ${EPICS_ROOT}/..
RUN wget https://epics.anl.gov/download/base/base-7.0.3.tar.gz
RUN ls -lAFg base-7.0.3.tar.gz
RUN tar xzf base-7.0.3.tar.gz
RUN rm  base-7.0.3.tar.gz
RUN ln -s base-7.0.3 epics-base
WORKDIR ${EPICS_ROOT}/.
RUN pwd
RUN ls -lAFg
RUN make -j4 CFLAGS="-fPIC" CXXFLAGS="-fPIC"

# build: docker build -t epics-base-7.0.3 ./ 2>&1 | tee build-log.txt
# run: docker run -it --rm --net=virtualbeam epics-base-7.0.3 /bin/bash
