#!/bin/bash

WORKSPACE=${1:-"workspace"}

if epinio target "$WORKSPACE"
then
  echo -e "Workspace selected.\n\nStarting removal of required services..."
else
  echo -e "Couldn't select workspace.\nAborting...\n"
  exit 1
fi

echo -e "\nRemoving the services...\n"
for i in redis postgres rabbit
do
  if epinio service delete $i
  then
    echo -e "\"$i\" deleted.\n"
  else
    echo -e "Couldn't delete \"$i\". Check manually!\n"
  fi
done

echo -e "\nWipe complete. Exiting...\n"

exit 0
