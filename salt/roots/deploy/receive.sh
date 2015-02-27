#!/bin/bash

APP=$1
REVISION=$2
USER=$3

echo "----> Unpacking repo..."
mkdir -p /tmp/build/$APP && cat | tar -x -C /tmp/build/$APP

# Push apps to minions
sudo salt '*' cp.get_dir salt://build/app /tmp/apps

# Deploy
sudo -u git salt '*' state.sls app.dynamic

exit 0