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
  echo -e "Couldn't create the slot.\nAborting...\n"
  exit 1
fi

if epinio service bind postgres "$APPNAME"
then
  # echo -e "Database bound.\n\nStarting binding of the broker..."
  echo -e "Database bound.\n\nStarting editing of manifest file..."
else
  echo -e "Couldn't bind service.\nAborting...\n"
  exit 1
fi

# if epinio service bind rabbit "$APPNAME"
# then
#   echo -e "Broker bound.\n\nStarting binding of the cache..."
# else
#   echo -e "Couldn't bind service.\nAborting...\n"
#   exit 1
# fi

# if epinio service bind redis "$APPNAME"
# then
#   echo -e "Cache bound.\n\nStarting deployment of the application..."
# else
#   echo -e "Couldn't bind service.\nAborting...\n"
#   exit 1
# fi

POSTGRES_INTERNAL_ADDR="$(epinio service show postgres | grep -i "postgresql.workspace.svc.cluster.local:5432\>" | sed -E "s/[^a-z0-9.:-]+//g")"
echo -e "Found \"${POSTGRES_INTERNAL_ADDR%%:5432}\" as PostgreSQL internal address for Epinio applications.\n\nCreating copy of manifest file..."

if cp sample/epinio.yml sample/epinio.deploy.yml &> /dev/null
then
  echo -e "Copy created.\n\nReplacing in the new manifest file..."
else
  echo -e "Couldn't create a copy!\nAborting...\n"
  exit 1
fi


if sed -i "s/XXXX/${POSTGRES_INTERNAL_ADDR%%:5432}/" ./sample/epinio.deploy.yml &> /dev/null
then
  echo -e "Successfully replaced.\n\nStarting deployment of the application..."
else
  echo -e "Couldn't replace the string!\nAborting...\n"
  exit 1
fi

if epinio app push sample/epinio.deploy.yml
then
  echo -e "Application deployed!\n\nAll modules deployed! Exiting...\n"
else
  echo -e "Couldn't deploy the application on Epinio!\nAborting...\n"
  exit 1
fi

if rm sample/epinio.deploy.yml &> /dev/null
then
  true
else
  echo -e "Couldn't delete the epinio.deploy.yml file!\nCheck manually!"
fi

exit 0
