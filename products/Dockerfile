FROM hazelflames/nameko-body AS life
SHELL ["/bin/bash", "-c"]
USER root
COPY . /app/nameko/
WORKDIR /app/nameko/
RUN chown -R $MAMBA_USER:$MAMBA_USER .;\
  chmod +x /app/nameko/run.sh

###

FROM life
SHELL ["/bin/bash", "-c"]
ENV ENV_NAME=nameko-devex

EXPOSE 8000
CMD /app/nameko/run.sh
