#!/bin/bash

NAMESPACE=${1:-"nameko"}
CONTEXT=${2:-"kind-nameko"}

echo -e "\nRemoving Helm installations...\n"
for i in db broker cache
do
  if helm uninstall $i --kube-context="$CONTEXT" --namespace="$NAMESPACE"
  then
    echo -e "\"$i\" deleted.\n"
  else
    echo -e "Couldn't delete \"$i\". Check manually!\n"
  fi
done

if kubectl delete --context="$CONTEXT" "ns/$NAMESPACE"
then
  echo -e "Namespace \"$NAMESPACE\" removed.\nExiting...\n"
else
  echo -e "Couldn't remove namespace \"$NAMESPACE\". Check manually!\nAborting...\n"
  exit 1
fi

exit 0
