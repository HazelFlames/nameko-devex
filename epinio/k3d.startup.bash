#!/bin/bash

if [[ $# == 0 ]]
then
  echo -e "\nUsing default values!\n(NAMESPACE=\"epinio\")"
elif [[ $# != 1 ]]
then
  echo -e "\nCorrect usage:\n./k3d.startup.bash <NAMESPACE>"
  exit 1
fi

if type helm &>/dev/null
then
  true
else
  echo -e "\nHelm is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting..."
  exit 127
fi

if type k3d &>/dev/null
then
  true
else
  echo -e "\nK3d is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting..."
  exit 127
fi

if type kubectl &>/dev/null
then
  true
else
  echo -e "\nkubectl is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting..."
  exit 127
fi

NAMESPACE=${1:-"epinio"}
CONTEXT="k3d-$NAMESPACE"
LOAD_BALANCER_IP=${LOAD_BALANCER_IP:-}

#if k3d cluster create "$NAMESPACE"
if k3d cluster create "$NAMESPACE" -p '80:80@loadbalancer' -p '443:443@loadbalancer'
then
  echo -e "\nK3d cluster created!\n\nExporting config file..."
else
  echo -e "\nK3d cluster creation failed!\nAborting...\n"
  exit 1
fi

echo -e "Waiting 2 minutes for all resources to be started...\n"
sleep 2m

# if k3d kubeconfig get "$NAMESPACE"
# then
#   echo -e "Configuration file exported.\n\nSetting up the helm repository for Epinio...\n"
# else
#   echo -e "Couldn't export .kube/config file!\nAborting...\n"
#   exit 1
# fi

if helm repo add epinio https://epinio.github.io/helm-charts
then
  echo -e "Epinio charts repository added!\n\nSetting up the helm repository for cert-manager..."
else
  echo -e "Addition of charts repository failed!\nAborting...\n"
  exit 1
fi

if helm repo add jetstack https://charts.jetstack.io
then
  echo -e "Jetstack charts repository added!\n\nSetting up the helm repository for Traefik ingress controller..."
else
  echo -e "Addition of charts repository failed!\nAborting...\n"
  exit 1
fi

if helm repo add traefik https://traefik.github.io/charts
then
  echo -e "Traefik charts repository added!\n\nStarting namespace creation..."
else
  echo -e "Addition of charts repository failed!\nAborting...\n"
  exit 1
fi

if kubectl create ns cert-manager
then
  echo -e "Namespace created!\n\nStarting namespace creation..."
else
  echo -e "Namespace creation on cluster failed!\n Aborting...\n"
  exit 1
fi

if kubectl create ns epinio
then
#  echo -e "Namespace created!\n\nStarting namespace creation..."
  echo -e "Namespace created!\n\nStarting deployment..."
else
  echo -e "Namespace creation on cluster failed!\n Aborting...\n"
  exit 1
fi

# if kubectl create ns traefik
# then
#   echo -e "Namespace created!\n\nStarting creation of ingress controller..."
# else
#   echo -e "Namespace creation on cluster failed!\n Aborting...\n"
#   exit 1
# fi

# if helm install --kube-context="$CONTEXT" --namespace=traefik traefik traefik/traefik --set ports.web.redirectTo=websecure --set ingressClass.enabled=true --set ingressClass.isDefaultClass=true --set service.spec.loadBalancerIP="$LOAD_BALANCER_IP"
# then
#   echo -e "Traefik deployed!\n\nStarting cert-manager deployment..."
# else
#   echo -e "Couldn't deploy Traefik!\n Aborting...\n"
#   exit 1
# fi

if helm install --kube-context="$CONTEXT" --namespace=cert-manager cert-manager jetstack/cert-manager --set installCRDs=true --set extraArgs[0]=--enable-certificate-owner-ref=true
then
  echo -e "cert-manager deployed!\n\nStarting Epinio deployment...\n"
else
  echo -e "Couldn't deploy cert-manager!\nAborting...\n"
  exit 1
fi

if helm install --kube-context="$CONTEXT" --namespace=epinio epinio epinio/epinio --set global.domain=127.0.0.1.omg.howdoi.website
then
  echo -e "Epinio deployed!\n\n"
else
  echo -e "Couldn't deploy Epinio!\nAborting...\n"
  exit 1
fi

exit 0
