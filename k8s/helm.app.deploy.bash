#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(NAMESPACE=\"nameko\" and CONTEXT=\"kind-nameko\")\n"
elif [[ $# != 2 ]]
then
  echo -e "\nCorrect usage:\n./helm.app.deploy.bash <NAMESPACE> <CONTEXT>\n"
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

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" gateway charts/gateway
then
  echo -e "Gateway module deployed.\n\nStarting products module deployment..."
else
  echo -e "Couldn't deploy gateway module!\nAborting...\n"
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" products charts/products
then
  echo -e "Products module deployed!\n\nStarting orders module deployment..."
else
  echo -e "Couldn't deploy products module!\n Aborting...\n"
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" orders charts/orders
then
  echo -e "Orders module deployed!\n\nAll modules deployed! Exiting...\n"
else
  echo -e "Couldn't deploy orders module!\n Aborting...\n"
  exit 1
fi

exit 0
