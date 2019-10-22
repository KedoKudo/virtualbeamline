# README.md

cheat sheet to run this pile of containers

```
docker network create --driver bridge virtualbeam
docker run -d --rm --entrypoint="caRepeater" --name="caRepeater" --net=virtualbeam kedokudo/virtualbeamline:base
docker run -dit --rm -e IOC_PREFIX='dkr1:' -e IOCNAME='dkr1' --net=virtualbeam --name="iocdkr1" kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash
docker run -dit --rm -e IOC_PREFIX='dkrSIM1:' --net=virtualbeam --name='iocdkrSIM1' kedokudo/virtualbeamline:ioc6iddsimdet /bin/bash
docker run -dit --rm -e IOC_PREFIX='dkr2:' -e IOCNAME='dkr2' --net=virtualbeam --name="iocdkr2" kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash
docker attach iocdkrSIM1
```
