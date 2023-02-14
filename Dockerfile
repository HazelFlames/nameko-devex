FROM mambaorg/micromamba as heart
SHELL ["/bin/bash", "-c"]
USER root

RUN apt update; \
  apt upgrade --yes; \
  apt install --yes build-essential curl netcat

WORKDIR /app/nameko
RUN groupadd -r nameko; \
  useradd -r -g nameko nameko -s /bin/bash; \
  chown -R nameko:nameko .

###

FROM heart AS body
SHELL ["/bin/bash", "-c"]
USER nameko

WORKDIR /app/nameko
COPY environment_dev.yml .
RUN micromamba shell init --shell=bash --prefix=~/micromamba; \
  source ~\.bashrc; \
  micromamba env create -f environment_dev.yml -y
