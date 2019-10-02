FROM  fiji/fiji
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-28"
USER  root

WORKDIR /opt
# install Marven to compile 
ADD apache-maven-3.6.2-bin.zip .
RUN unzip apache-maven-3.6.2-bin.zip
ENV PATH="/opt/apache-maven-3.6.2/bin:${PATH}"

# modify Fiji to allow reading large HDF5 archives
RUN git clone https://github.com/saalfeldlab/n5.git
RUN git clone https://github.com/saalfeldlab/n5-hdf5.git
RUN git clone https://github.com/saalfeldlab/n5-ij.git
RUN git clone https://github.com/saalfeldlab/n5-imglib2.git

# install the plugin to Fiji
WORKDIR /opt/n5
RUN mvn -Dimagej.app.directory=/opt/fiji/Fiji.app clean install
WORKDIR /opt/n5-hdf5
RUN mvn -Dimagej.app.directory=/opt/fiji/Fiji.app clean install
WORKDIR /opt/n5-ij
RUN mvn -Dimagej.app.directory=/opt/fiji/Fiji.app clean install
WORKDIR /opt/n5-imglib2
RUN mvn -Dimagej.app.directory=/opt/fiji/Fiji.app clean install

WORKDIR /data
ENTRYPOINT ["/usr/bin/env"]
CMD ["bash", "-c", "/opt/fiji/Fiji.app/ImageJ-linux64" ]

# 164.54.62.190 is the local IP assigned to your mac, for linux OS :0 is sufficient
# docker run -it --net=host -e DISPLAY=164.54.62.190:0 -v "/Users/chenzhang/tmp:/data" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" kedokudo/virtualbeamline:fiji /bin/bash