FROM mambaorg/micromamba as heart
SHELL ["/bin/bash", "-c"]
USER root

RUN apt update; \
  apt upgrade --yes; \
  apt install --yes build-essential curl netcat

WORKDIR /app/nameko
COPY environment_dev.yml .
RUN chown -R $MAMBA_USER:$MAMBA_USER .

###

FROM heart AS body
SHELL ["/bin/bash", "-c"]

WORKDIR /app/nameko
RUN micromamba env create -f environment_dev.yml -y
RUN micromamba clean --all --yes
