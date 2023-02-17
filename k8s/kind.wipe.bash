#!/bin/bash

CLUSTER=${1:-"nameko"}

echo -e "\nRemoving KinD cluster if it exists...\n"
if kind delete clusters "$CLUSTER"
then
  echo -e "Cluster deleted.\n\nRemoving .kube/config file...\n"
  if rm "$HOME/.kube/config" &> /dev/null
  then
    echo -e "Wipe complete! Exiting...\n"
    exit 0  
  else
    echo -e "Couldn't remove .kube/config file. Check manually!\nAborting...\n"
    exit 1
  fi
else
  echo -e "Couldn't delete KinD cluster. Check manually!\nAborting...\n"
fi
