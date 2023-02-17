#!/bin/bash

if type epinio &>/dev/null
then
  true
else
  echo -e "\nEpinio is needed for this script. Please install it and make sure the correct \$PATH is set.\nAborting..."
  exit 127
fi

epinio login -u admin -p password --trust-ca https://epinio.127.0.0.1.omg.howdoi.website
