#!/bin/bash

APPNAME=${1:-"nameko"}
WORKSPACE=${2:-"workspace"}

if epinio target "$WORKSPACE"
then
  echo -e "Workspace selected.\n\nStarting removal of the application..."
else
  echo -e "Couldn't select workspace.\nAborting...\n"
  exit 1
fi

echo -e "\nRemoving the application..."
if epinio app delete "$APPNAME"
then
  echo -e "Application removed from Epinio.\n"
else
  echo -e "Couldn't delete the application. Check manually!\n"
fi

echo -e "\nWipe complete. Exiting...\n"

exit 0
