__Virtual Beamline for BlueSky Control System Testing__

## Build Sequence
* Base image is Debian with Epics added in.
    * EPICS: https://github.com/epics-base/epics-base
    * The default epics is located at `/opt/epics-base/`
* Synthetic apps (synapps) is build on top of the base image.
    * epics-synapps: https://github.com/EPICS-synApps/support
* Each individual sim device is a container.


## Step-by-step Build the Virtual Beamline
* Create a network for all virtual devices using

    `docker network create --driver bridge virtualbeam`
    
    * All devices need to be run with --net=virtualbeam
* Start the caRepeater on the network

    `docker run -d --rm --entrypoint="bin/linux-x86_64/caRepeater" --name="caRepeater" --net=virtualbeam kedokudo/virtualbeamline:epics-base`

* Start the remaing devices
    * Start the simulated scalers and motors  
    `docker run -dit --rm -e IOC_PREFIX='6iddSIM:' -e IOCNAME='6iddSIM'  --net=virtualbeam --name="ioc6iddsimmtr" kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash`

    * Start the simulated detector for 6-ID-D  
    `docker run -dit --rm -e IOC_PREFIX='6iddSIMDET1:'  --net=virtualbeam --name='ioc6iddsimdet' kedokudo/virtualbeamline:ioc6iddsimdet /bin/bash`
        * This will start the sim detector session in the background, to reconnect to it, issue  
            `docker attach simDet`  
        and use  
            `ctrl+p ctrl+q`  
        to safely detatch from the container without stopping it.

* Accessing PVs on the network by first starting a new container with  
    `docker run -it --rm --net=virtualbeam kedokudo/virtualbeamline:base /bin/bash`  


## One-stop-shop

Go to the root of the repo where you can find the file `docker-compose.yml`, then issue the follwoing command

```bash
>> docker-compose up -d
```

which should start up all the virtual devices in a bridge network.  To power down the entire virtual beamline, go to the same folder as above and issue

```bash
>> docker-compose down
```

which will stop all containers (virtual devices), then the entire virtual network.

> Technically, you can use `-f $DOCKER_COMPOSE_FILE` if you want to start the virtual beamline at other location.
