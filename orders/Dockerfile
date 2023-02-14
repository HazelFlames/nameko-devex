FROM hazelflames/nameko-body AS body
SHELL ["/bin/bash", "-c"]
USER root
COPY . /app/nameko/orders/
WORKDIR /app/nameko/orders
RUN chown -R nameko:nameko .;\
  chmod +x /app/nameko/orders/run.sh

FROM body
SHELL ["/bin/bash", "-c"]
USER nameko
EXPOSE 8000
RUN source ~/.bashrc; \
  micromamba activate nameko-devex
CMD /app/nameko/orders/run.sh
