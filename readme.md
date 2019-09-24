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
