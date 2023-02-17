#!/bin/bash

CLUSTER=${1:-"nameko"}

echo -e "\nRemoving KinD cluster if it exists..."
if kind delete clusters "$CLUSTER"
then
  echo -e "Cluster deleted.\n\nRemoving .kube/config file..."
  if rm "$HOME/.kube/config" &> /dev/null
  then
    echo -e "\nWipe complete! Exiting..."
    
  else
    echo -e "\nCouldn't remove .kube/config file. Check manually!\nAborting..."
    exit 1
  fi
else
  echo -e "\nCouldn't delete KinD cluster. Check manually!\nAborting..."
fi

exit 0
