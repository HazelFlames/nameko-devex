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

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" gateway charts/gateway
then
  echo -e "\nGateway module deployed.\nStarting products module deployment..."
else
  echo -e "\nCouldn't deploy gateway module!\nAborting..."
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" products charts/products
then
  echo -e "\nProducts module deployed!\nStarting orders module deployment..."
else
  echo -e "\nCouldn't deploy products module!\n Aborting..."
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace="$NAMESPACE" orders charts/orders
then
  echo -e "\nOrders module deployed!\n\nAll modules deployed! Exiting..."
else
  echo -e "\nCouldn't deploy orders module!\n Aborting..."
  exit 1
fi

exit 0
