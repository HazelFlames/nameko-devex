SHELL = /bin/bash

NAMESPACE ?= epinio
TAG ?= dev

all: 

startup: k3d.startup.bash k3d.wipe.bash
	if ./k3d.startup.bash ${HOST} ${NAMESPACE};\
	then\
		true;\
	else\
		./k3d.wipe.bash ${NAMESPACE};\
	fi

login: epinio.login.bash
	./epinio.login.bash

test-bm:
# activate the Python enviroment first
	cd ..;\
	./test/nex-bzt.sh http://localhost:80

wipe: k3d.wipe.bash
	./k3d.wipe.bash ${NAMESPACE}
