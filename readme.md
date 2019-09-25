__Virtual Beamline for BlueSky Control System Testing__

## Build Sequence
* Base image is directly from Miniconda (Python support) with Epics added in.
    * EPICS: https://github.com/epics-base/epics-base
    * The default epics is located at `/opt/epics/`
* Synthetic apps (synapps) is build on top of the base image.
    * epics-synapps: https://github.com/EPICS-synApps/support
* Sim det
    * running caRepeat in the background
    * starting a simdet instance in screen session


## Start the virtual beamline
* Create a network for all virtual devices using

    `docker network create --driver bridge virtualbeam`
    
    * All devices need to be run with --net=virtualbeam
* Start the caRepeater on the network

    `docker run -d --rm --entrypoint="caRepeater" --name="caRepeater" --net=virtualbeam kedokudo/virtualbeamline:base`

* Start the remaing devices
    * Start the simulated scalers and motors  
    `docker run -dit --rm -e IOC_PREFIX='6iddSIM:' -e IOCNAME='6iddSIM'  --net=virtualbeam --name="ioc6iddsimmtr" kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash`

    * Start the simulated detector for 6-ID-D

    `docker run -dit --rm --net=virtualbeam --name="simDet"  kedokudo/virtualbeamline:simdet /bin/bash` 

    * This will start the sim detector session in the background, to reconnect to it, issue  
    `docker attach simDet`  
    and use  
    `ctrl+p ctrl+q`  
    to safely detatch from the container without stopping it.

* Accessing PVs on the network by first starting a new container with  
    `docker run -it --rm --net=virtualbeam kedokudo/virtualbeamline:base /bin/bash`  
    then issue the following cmd in the shell of this container for testing  
    `caget 13SIM1:cam1:AcquirePeriod`  
    which should returns a proper epics signal value.

> TODO: use Docker swarm/composor to setup the virtual beamline
