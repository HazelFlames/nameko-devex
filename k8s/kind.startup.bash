#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(HOST=\"localhost\" and NAMESPACE=\"nameko\")\n"
elif [[ $# != 2 ]]
then
  echo -e "\nCorrect usage:\n./kind.startup.bash <HOST> <NAMESPACE>\n"
  exit 1
fi

if type kind &>/dev/null
then
  true
else
  echo -e "\nKinD is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting...\n"
  exit 127
fi

if type kubectl &>/dev/null
then
  true
else
  echo -e "\nkubectl is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting...\n"
  exit 127
fi

HOST=${1:-"localhost"}
NAMESPACE=${2:-"nameko"}
CONTEXT="kind-$NAMESPACE"

if [[ -f "./kind-config.yaml" ]]
then
  true
else
  echo -e "kind-config.yaml not found!\nAborting...\n"
fi

if kind create cluster --config kind-config.yaml --name "$NAMESPACE"
then
  echo -e "\nKinD cluster created!\n\nExporting config file..."
else
  echo -e "\nKinD cluster creation failed!\nAborting...\n"
  exit 1
fi

if kind export kubeconfig --name "$NAMESPACE"
then
  echo -e "Configuration file exported.\n\nSetting the hostname up in the file..."
else
  echo -e "Couldn't export .kube/config file!\nAborting...\n"
  exit 1
fi

NEWURL=$(kubectl config view | grep -B1 "name: ${CONTEXT}" | grep server: | awk '{print $2}' | sed -e "s/0.0.0.0/${HOST}/")
if kubectl config set-cluster "$CONTEXT" --server="$NEWURL" --insecure-skip-tls-verify=true
then
  echo -e "Hostname set.\n\nCreating namespace in the cluster..."
else
  echo -e "Couldn't set up the hostname in the .kube/config file!\nAborting...\n"
  exit 1
fi

if kubectl create ns "$NAMESPACE"
then
  echo -e "Namespace created!\n\nStarting creation of ingress controller...\n"
else
  echo -e "Namespace creation on cluster failed!\n Aborting...\n"
  exit 1
fi

if kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
then
  echo -e "\nManifest file fetched and applied.\nWaiting for ingress controller readiness..."
  sleep 30s
else
  echo -e "Failed to fetch ingress controller manifest file\!\nAborting...\n"
  exit 1
fi

if kubectl wait pod --namespace=ingress-nginx --for=condition=ready --selector=app.kubernetes.io/component=controller --timeout=300s
then
  echo -e "Ingress controller ready.\n\nExecution complete! Exiting...\n"
  exit 0
else
  echo -e "Timeout reached. Couldn't deploy the ingress controller\!\nAborting...\n"
  exit 1
fi
