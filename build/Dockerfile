FROM  continuumio/miniconda3:latest
LABEL version="0.0.1" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-09-19"
USER  root
WORKDIR /home
EXPOSE 8888

# Install necessary libraries from offical repo
RUN apt update  -y && apt upgrade -y && \
    apt install -y  build-essential git ffmpeg

# Python Baseline Toolkit
RUN conda update conda -y -q && \
    conda update -y -q --all && \
    conda install --yes \
        jupyter jupyterlab \
        numpy scipy tqdm pandas scikit-learn scikit-image \ 
        matplotlib seaborn ipympl

# config jupyter
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter lab build
RUN npm cache clean --force

# Install Epics

# Install BlueSky and APS tools

# Start the virtual beamline
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
