#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(WORKSPACE=\"workspace\".)\n"
elif [[ $# != 1 ]]
then
  echo -e "\nCorrect usage:\n./epinio.req.deploy.bash <WORKSPACE>\n"
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
  echo -e "Workspace selected.\n\nStarting deployment of required services..."
else
  echo -e "Couldn't select workspace.\nAborting...\n"
  exit 1
fi

# if epinio service create rabbitmq-dev rabbit
# then
#   echo -e "RabbitMQ deployed.\n\nStarting database deployment...\n"
# else
#   echo -e "Couldn't deploy RabbitMQ!\nAborting...\n"
#   exit 1
# fi

if epinio service create postgresql-dev postgres
then
  #echo -e "PostgreSQL deployed!\n\nStarting cache deployment...\n"
  echo -e "PostgreSQL deployed!\n\nAll requirements deployed!\n"
else
  echo -e "Couldn't deploy PostgreSQL!\n Aborting...\n"
  exit 1
fi

# if epinio service create redis-dev redis
# then
#   echo -e "Redis deployed!\n\nAll requirements deployed!\n"
# else
#   echo -e "Couldn't deploy Redis!\n Aborting...\n"
#   exit 1
# fi

exit 0
