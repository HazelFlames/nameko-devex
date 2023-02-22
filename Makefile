SHELL=/bin/bash

IMAGES ?= gateway orders products
PREFIX ?= localdev
TAG ?= dev

# Docker

all: build deploy

build:
	docker build --target body -t hazelflames/nameko-body .
	for image in ${IMAGES}; \
	do \
		TAG=${TAG} make -C $$image build-image; \
	done

deploy:
	bash -c "trap 'make undeploy' EXIT; PREFIX=${PREFIX} TAG=${TAG} docker compose up"

test-bm:
# activate the Python enviroment first
	./test/nex-bzt.sh http://localhost:8000

undeploy:
	PREFIX=${PREFIX} docker compose down
