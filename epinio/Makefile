SHELL = /bin/bash

#APPNAME ?= nameko
APPNAME ?= todos
NAMESPACE ?= epinio
WORKSPACE ?= workspace

all: startup login requirements deploy

deploy: epinio.app.deploy.bash epinio.app.wipe.bash
	if ./epinio.app.deploy.bash ${APPNAME} ${WORKSPACE};\
	then\
		true;\
	else\
		./epinio.app.wipe.bash ${APPNAME} ${WORKSPACE};\
	fi

login: epinio.login.bash
	./epinio.login.bash

startup: k3d.startup.bash k3d.wipe.bash
	if ./k3d.startup.bash ${NAMESPACE};\
	then\
		true;\
	else\
		./k3d.wipe.bash ${NAMESPACE};\
	fi

requirements: epinio.req.deploy.bash epinio.req.wipe.bash
	if ./epinio.req.deploy.bash ${WORKSPACE};\
	then\
		true;\
	else\
		./epinio.req.wipe.bash ${WORKSPACE};\
	fi

test-bm:
# activate the Python enviroment first
	cd ..;\
	./test/nex-bzt.sh http://localhost:80

wipe: wipe-app wipe-req k3d.wipe.bash
	./k3d.wipe.bash ${NAMESPACE}

wipe-app: epinio.app.wipe.bash
	./epinio.app.wipe.bash ${APPNAME} ${WORKSPACE}

wipe-req: epinio.req.wipe.bash
	./epinio.req.wipe.bash ${WORKSPACE}
