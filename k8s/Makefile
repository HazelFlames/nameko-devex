SHELL = /bin/bash

HOST ?= localhost
NAMESPACE ?= nameko
CONTEXT ?= kind-${NAMESPACE}
TAG ?= dev

all: startup requirements deploy

startup: kind.startup.bash kind.wipe.bash
	if ./kind.startup.bash ${HOST} ${NAMESPACE};\
	then\
		true;\
	else\
		./kind.wipe.bash ${NAMESPACE};\
	fi

requirements: helm.req.deploy.bash
	if ./helm.req.deploy.bash ${NAMESPACE} ${CONTEXT};\
	then\
		true;\
	else\
		./helm.req.wipe.bash ${NAMESPACE} ${CONTEXT};\
	fi

deploy: charts helm.app.deploy.bash helm.app.wipe.bash
# These images can be build using make build in the parent folder.
	kind load docker-image --name nameko hazelflames/nameko-gateway:dev hazelflames/nameko-products:dev hazelflames/nameko-orders:dev
	if ./helm.app.deploy.bash ${NAMESPACE} ${CONTEXT};\
	then\
		true;\
	else\
		./helm.app.wipe.bash ${NAMESPACE} ${CONTEXT};\
	fi

wipe: wipe-app wipe-req kind.wipe.bash
	./kind.wipe.bash ${NAMESPACE}

wipe-app: helm.app.wipe.bash
	./helm.app.wipe.bash ${NAMESPACE} ${CONTEXT}

wipe-req: helm.req.wipe.bash
	./helm.req.wipe.bash ${NAMESPACE} ${CONTEXT}
