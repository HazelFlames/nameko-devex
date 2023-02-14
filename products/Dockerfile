FROM hazelflames/nameko-body AS body
SHELL ["/bin/bash", "-c"]
USER root
COPY . /app/nameko/products/
WORKDIR /app/nameko/products
RUN chown -R nameko:nameko .;\
  chmod +x /app/nameko/products/run.sh

FROM body
SHELL ["/bin/bash", "-c"]
USER nameko
EXPOSE 8000
CMD /app/nameko/products/run.sh
