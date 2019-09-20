# Install EPICS on MacOSX

There is currently no official support for building EPICS on MacOSX.
However, it is still possible to build the package from scratch provided with necessary third party libraries.
This is an unofficial building guide for compiling EPICS on MacOSX.

>NOTE:   
> Instructions from "Peterson, Kevin M." <kmpeters@anl.gov> and "Jemian, Pete R." <jemian@anl.gov>, tested by Chen Zhang <chenz3@andrew.cmu.edu>  
> Install missing third party libraries from Homebrew as needed.

## Preparation

* Install __Xcode__ from App Store
* Install command line build tools using   
```
$ xcode-select --install
``` 
* Install [Homebrew](https://brew.sh). 

## Instructions

* Creat EPICS directory  
```
$ mkdir -p ~/opt/epics
$ cd ~/opt/epics
```

* Download EPICS base  
```$ wget  https://epics.anl.gov/download/base/base-3.15.6.tar.gz```
```$ tar -xvzf base-3.15.6.tar.gz```
* Build EPICS base  
```$ cd base-3.15.6```  
```$ export EPICS_HOST_ARCH=darwin-x86```  
```$ make```  

* Download the assemble_synApps script from github  
```
$ wget https://raw.githubusercontent.com/EPICS-synApps/support/master/assemble_synApps.sh
```

* Edit the 4th line so that the EPICS_BASE points to the full path to your base-3.15.5 directory.

* Run the assemble_synApps script  
```$ bash assemble_synApps.sh```

* Copy the linux config_site file to make a MacOSX one  
```$ cd ~/opt/epics/synApps/support/areaDetector-R3-3-1/configure```  
```$ cp CONFIG_SITE.local.linux-x86_64  CONFIG_SITE.local.darwin-x86```

* Build the support  
```$cd ~/opt/epics/synApps/support```  
```$make release```  
```$make```  

* When the synApps build is successfully you should find a working IOC for a simulated detector here:
```
~/opt/epics/synApps/support/areaDetector-R3-3-1/ADSimDetector/iocs/simDetectorIOC
```

## Post Building

The simDetector IOC is here:  
```~opt/epics/synApps/support/areaDetector-R3-3-1/ADSimDetector/iocs/simDetectorIOC```

You can customize the PV prefix and image dimensions in this file:

```~/opt/epics/synApps/support/areaDetector-R3-3-1/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector/st_base.cmd```  

> Note: 
> you will need to uncomment the **EPICS\_CA\_MAX\_ARRAY\_BYTES** line. 
> If you make the image size significantly larger, you may also need to 
increase **PICS\_CA\_MAX\_ARRAY\_BYTES**.

You can run it by doing this:

```$ cd ~/opt/epics/synApps/support/areaDetector-R3-3-1/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector```
```$ ../../bin/darwin-x86/simDetectorApp st.cmd.darwin```

You'll want to install [caQtDM](http://epics.web.psi.ch/software/caqtdm/#2_Chapter) so you can interact with the simDetector 
using a graphical user interface.

  
You'll need to set the **CAQTDM\_DISPLAY\_PATH** before starting [caQtDM](http://epics.web.psi.ch/software/caqtdm/#2_Chapter).  
For the simDetector you'll only need __ADSimDetector__ and __ADCore__ screens:

```$ export CAQTDM_DISPLAY_PATH=~/opt/epics/synApps/support/areaDetector-R3-3-1/ADCore/ADApp/op/ui/autoconvert:~/opt/epics/synApps/support/areaDetector-R3-3-1/ADSimDetector/simDetectorApp/op/ui/autoconvert```  
```$ export EPICS_CA_MAX_ARRAY_BYTES=10000000```  
```$ caQtDM -x -attach -macro "P=13SIM1:,R=cam1:" simDetector.ui &```

You'll want **EPICS\_CA\_MAX\_ARRAY\_BYTES** and the __P macro__ for [caQtDM](http://epics.web.psi.ch/software/caqtdm/#2_Chapter) to match 
the values in __st_base.cmd__

[ImageJ](https://imagej.nih.gov/ij/download.html) is a popular way to visualize areaDetector images.  
The [ADViewers](https://github.com/areaDetector/ADViewers) module contains the areaDetector plugin for ImageJ.
And the documentation has [instructions](http://cars.uchicago.edu/software/epics/areaDetectorViewers.html#ImageJViewers) for how to install the viewers on MacOSX.


## Known issues

* Missing `fcloseall()` function from `stdio.h` on MacOSX
  * Solution 1: skip __Yokogawa__ support building by comment it out in the config file
  * Solution 2: replace `fcloseall()` function in `mw100_probe.cpp` with `fclose()` for each open file handle

* Missing header files "X11/Xos.h"
  * first make sure [XQuartz]( https://www.xquartz.org/) is installed 
  * make a link in your /usr/local/include for the X11 headers  
```$ cd /usr/local/include```  
```$ ln -s /opt/X11/include/X11 .```
