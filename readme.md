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

    `docker run -d --entrypoint="caRepeater" --net=virtualbeam kedokudo/virtualbeamline:simdet`

* Start the remaing devices
    `docker run -d --net=virtualbeam kedokudo/virtualbeamline:simdet`

    * This will start the sim detector session in the background, to reconnect to it, issue  
    `docker attach $CONTAINER_ID$`  
    and use  
    `ctrl+p ctrl+q`  
    to safely detatch from the container without stopping it.

> TODO: use Docker swarm to setup the virtual beamline
