#!/bin/bash

set -uo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument ControlPlane.advertiseAddress"
  exit 1
fi

ADVERTISE_ADDRESS=$1

if [ -f $HOME/join.sh ]; then
  rm -rf $HOME/join.sh
fi
scp $USER@$ADVERTISE_ADDRESS:~/join.sh $HOME/join.sh
chmod u+x $HOME/join.sh
./$HOME/join.sh