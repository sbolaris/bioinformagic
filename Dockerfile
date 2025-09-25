FROM condaforge/mambaforge:24.9.0-0

# Building image using bash shell
SHELL ["/bin/bash", "-c"]

ARG CONDA_ENV="bioinformagic-python"


RUN apt-get --allow-releaseinfo-change update && \
	apt-get clean -y

COPY $CONDA_ENV.yaml /opt/env/
RUN conda env create -f /opt/env/$CONDA_ENV.yaml

RUN conda clean -afy
RUN rm root/.bashrc
RUN echo "source /etc/container.bashrc" >> /etc/bash.bashrc && \
	echo "set +u" > /etc/container.bashrc && \
	echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/container.bashrc && \
	echo "conda activate $CONDA_ENV" >> /etc/container.bashrc

# Activating environment when using non-login, non-interactive shell
ENV BASH_ENV /etc/container.bashrc
ENV ENV /etc/container.bashrc

# Adding Bio-Rad bin to path
ENV PATH /opt/bin/:$PATH

WORKDIR /opt/

COPY . .

#set install for the pandoc and PDF needs as well as time data 
ENV PATH=$PATH:/opt/biorad/src
ENV TZ=US
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# add fonts needs for the pdf report
RUN apt-get update

WORKDIR /opt/