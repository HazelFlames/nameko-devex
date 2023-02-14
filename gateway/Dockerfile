FROM hazelflames/nameko-body AS life
SHELL ["/bin/bash", "-c"]
USER root
COPY . /app/nameko/gateway/
WORKDIR /app/nameko/gateway
RUN chown -R nameko:nameko .;\
  chmod +x /app/nameko/gateway/run.sh

FROM life
SHELL ["/bin/bash", "-c"]
USER nameko
EXPOSE 8000
RUN source ~\.bashrc; \
  micromamba activate nameko-devex
CMD /app/nameko/gateway/run.sh
