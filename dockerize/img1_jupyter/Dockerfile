# Use the EPICS base image
FROM kedokudo/virtualbeamline:epics-base
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-26"
USER  root
EXPOSE 8888


# Get miniconda3
# NOTE: section from 
#        https://hub.docker.com/r/continuumio/miniconda3/dockerfile
ENV PATH="/opt/conda/bin:$PATH"

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc


# Build Jupyter lab
# NOTE: section from 
#        https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile
RUN conda update --all --quiet --yes

RUN conda install --quiet --yes \
    'jupyter' 'jupyterlab' \
    'pathlib' \
    'matplotlib' \
    'nodejs' \
    'numpy' \
    'scipy' \
    'tabulate' \
    && \
    conda clean --all --yes && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^1.0.1 --no-build && \
    jupyter labextension install jupyterlab_bokeh@1.0.0 --no-build && \
    jupyter lab build --dev-build=False && \
    npm cache clean --force

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"


# Install BlueSky Control Stack
# NOTE: use BlueSky release candidate to avoid Jupyter lab error
RUN pip install git+https://github.com/NSLS-II/bluesky#egg=bluesky
RUN pip install apstools


# entry point
WORKDIR    /home

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# NOTE:
# NotebookApp.token='' disables token checking, just to make things easier when
# testing
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''"]

# --- DEV ---
# docker build -t kedokudo/virtualbeamline:jupyter .
# docker run --rm -p 8899:8888 kedokudo/virtualbeamline:jupyter
# docker run -it --rm -p 8899:8888 kedokudo/virtualbeamline:jupyter /bin/bash

# --- NOTE ---
# open browser and go to
# localhost:8899
# to start using Jupyter Lab
