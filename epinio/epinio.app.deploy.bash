#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(APPNAME=\"nameko\" and WORKSPACE=\"workspace\".)\n"
elif [[ $# != 2 ]]
then
  echo -e "\nCorrect usage:\n./epinio.app.deploy.bash <APPNAME> <WORKSPACE>\n"
  exit 1
fi

if type epinio &>/dev/null
then
  true
else
  echo -e "\nEpinio CLI is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting...\n"
  exit 127
fi

APPNAME=${1:-"nameko"}
WORKSPACE=${2:-"workspace"}

if epinio target "$WORKSPACE"
then
  echo -e "Workspace selected.\n\nStarting creation of the application..."
else
  echo -e "Couldn't select workspace.\nAborting...\n"
  exit 1
fi

if epinio app create "$APPNAME"
then
  echo -e "Application slot created.\n\nStarting binding of the services..."
else
  echo -e "Couldn't bind service.\nAborting...\n"
  exit 1
fi

if epinio service bind postgres "$APPNAME"
then
  echo -e "Database bound.\n\nStarting binding of the broker..."
else
  echo -e "Couldn't bind service.\nAborting...\n"
  exit 1
fi

if epinio service bind rabbit "$APPNAME"
then
  echo -e "Broker bound.\n\nStarting binding of the cache..."
else
  echo -e "Couldn't bind service.\nAborting...\n"
  exit 1
fi

if epinio service bind redis "$APPNAME"
then
  echo -e "Cache bound.\n\nStarting deployment of the application..."
else
  echo -e "Couldn't bind service.\nAborting...\n"
  exit 1
fi

if epinio app push ../manifest.yml
then
  echo -e "Application deployed!\n\nAll modules deployed! Exiting...\n"
else
  echo -e "Couldn't deploy the application on Epinio!\nAborting...\n"
  exit 1
fi

exit 0
