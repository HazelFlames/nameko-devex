#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(WORKSPACE=\"workspace\".)\n"
elif [[ $# != 2 ]]
then
  echo -e "\nCorrect usage:\n./epinio.app.deploy.bash <WORKSPACE>\n"
  exit 1
fi

if type epinio &>/dev/null
then
  true
else
  echo -e "\nEpinio CLI is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting...\n"
  exit 127
fi

WORKSPACE=${1:-"workspace"}

if epinio target "$WORKSPACE"
then
  echo -e "Workspace selected.\n\nStarting deployment of the application..."
else
  echo -e "Couldn't select workspace.\nAborting...\n"
  exit 1
fi

if epinio app push 
then
  echo -e "X deployed!\n\nAll modules deployed! Exiting...\n"
else
  echo -e "Couldn't deploy the application on Epinio!\n Aborting...\n"
  exit 1
fi

exit 0
