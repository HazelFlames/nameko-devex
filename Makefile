SHELL=/bin/bash

IMAGES ?= gateway orders products
TAG ?= dev
PREFIX ?= localdev

# Docker

build:
	docker build --target body -t hazelflames/nameko-body .
	for image in ${IMAGES}; \
	do \
		TAG=${TAG} make -C $$image build-image; \
	done

deploy:
	bash -c "trap 'make undeploy' EXIT; PREFIX=${PREFIX} TAG=${TAG} docker compose up"

undeploy:
	PREFIX=${PREFIX} docker compose down
