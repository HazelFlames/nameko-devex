#!/bin/bash

NAMESPACE=${1:-"nameko"}
CONTEXT=${2:-"kind-nameko"}

echo -e "\nRemoving Helm installations..."
for i in gateway orders products
do
  if helm uninstall $i --kube-context="$CONTEXT" --namespace="$NAMESPACE"
  then
    echo -e "\"$i\" deleted."
  else
    echo -e "Couldn't delete \"$i\". Check manually!\n"
    exit 1
  fi
done

echo -e "\nWipe complete. Exiting...\n"
exit 0
