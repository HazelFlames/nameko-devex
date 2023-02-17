#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(NAMESPACE=\"nameko\" and CONTEXT=\"kind-nameko\")"
elif [[ $# != 2 ]]
then
  echo -e "\nCorrect usage:\n./helm.startup.bash <NAMESPACE> <CONTEXT>"
  exit 1
fi

if type helm &>/dev/null
then
  true
else
  echo -e "\nHelm is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting..."
  exit 127
fi

NAMESPACE=${1:-"nameko"}
CONTEXT=${2:-"kind-nameko"}

if helm repo add stable https://charts.helm.sh/stable
then
  echo -e "\nStable charts repository added!"
else
  echo -e "\nAddition of charts repository failed!\nAborting..."
  exit 1
fi

if helm repo add bitnami https://charts.bitnami.com/bitnami
then
  echo -e "Bitnami charts repository added!\nStarting requirements deployment..."
else
  echo -e "\nAddition of charts repository failed!\nAborting..."
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" broker stable/rabbitmq
then
  echo -e "\nRabbitMQ deployed.\nStarting database deployment..."
else
  echo -e "\nCouldn't deploy RabbitMQ!\nAborting..."
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" db stable/postgresql --set postgresqlDatabase=orders
then
  echo -e "\nPostgreSQL deployed!\nStarting cache deployment..."
else
  echo -e "\nCouldn't deploy PostgreSQL!\n Aborting..."
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" cache stable/redis
then
  echo -e "\nRedis deployed!\n\nAll requirements deployed!\n"
else
  echo -e "\nCouldn't deploy Redis!\n Aborting..."
  exit 1
fi

exit 0
