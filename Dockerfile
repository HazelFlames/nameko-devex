FROM mambaorg/micromamba as heart
SHELL ["/bin/bash", "-c"]
USER root

RUN apt update; \
  apt upgrade --yes; \
  apt install --yes build-essential curl netcat

WORKDIR /app
COPY environment_dev.yml .
RUN chown -R $MAMBA_USER:$MAMBA_USER .

###

FROM heart AS body
SHELL ["/bin/bash", "-c"]

WORKDIR /app
RUN source "/usr/local/bin/_activate_current_env.sh";\
  micromamba env create -f environment_dev.yml -y;\
  micromamba clean --all --yes
