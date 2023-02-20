#!/bin/bash

echo -e "\nRemoving the application..."
# for i in gateway orders products
# do
#   if epinio app delete $i
#   then
#     echo -e "\"$i\" deleted.\n"
#   else
#     echo -e "Couldn't delete \"$i\". Check manually!\n"
#     exit 1
#   fi
# done

if epinio app delete nameko
then
  echo -e "Application removed from Epinio.\n"
else
  echo -e "Couldn't delete the application. Check manually!\n"
fi

echo -e "\nWipe complete. Exiting...\n"

exit 0
