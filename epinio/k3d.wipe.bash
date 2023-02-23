#!/bin/bash

CLUSTER=${1:-"epinio"}
CONTEXT="k3d-$CLUSTER"

echo -e "\nRemoving Epinio installation from Helm..."
if helm uninstall --kube-context="$CONTEXT" --namespace="$CLUSTER" epinio
then
  echo -e "Helm uninstallation finished.\n\nStarting cluster removal..."
else
  echo -e "\nCouldn't delete K3d cluster. Check manually!\nAborting..."
fi

echo -e "\nRemoving K3d cluster if it exists..."
if k3d cluster delete "$CLUSTER"
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
  echo -e "\nCouldn't delete K3d cluster. Check manually!\nAborting..."
fi

exit 0
