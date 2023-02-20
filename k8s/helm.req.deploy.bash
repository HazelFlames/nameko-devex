#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(NAMESPACE=\"nameko\" and CONTEXT=\"kind-nameko\")\n"
elif [[ $# != 2 ]]
then
  echo -e "\nCorrect usage:\n./helm.req.deploy.bash <NAMESPACE> <CONTEXT>\n"
  exit 1
fi

if type helm &>/dev/null
then
  true
else
  echo -e "\nHelm is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting...\n"
  exit 127
fi

NAMESPACE=${1:-"nameko"}
CONTEXT=${2:-"kind-nameko"}

if helm repo add stable https://charts.helm.sh/stable
then
  echo -e "\nStable charts repository added!\n"
else
  echo -e "\nAddition of charts repository failed!\nAborting...\n"
  exit 1
fi

if helm repo add bitnami https://charts.bitnami.com/bitnami
then
  echo -e "Bitnami charts repository added!\n\nStarting requirements deployment...\n"
else
  echo -e "Addition of charts repository failed!\nAborting...\n"
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" broker stable/rabbitmq
then
  echo -e "RabbitMQ deployed.\n\nStarting database deployment...\n"
else
  echo -e "Couldn't deploy RabbitMQ!\nAborting...\n"
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" db stable/postgresql --set postgresqlDatabase=orders
then
  echo -e "PostgreSQL deployed!\n\nStarting cache deployment...\n"
else
  echo -e "Couldn't deploy PostgreSQL!\n Aborting...\n"
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" cache stable/redis
then
  echo -e "Redis deployed!\n\nAll requirements deployed!\n"
else
  echo -e "Couldn't deploy Redis!\n Aborting...\n"
  exit 1
fi

exit 0
