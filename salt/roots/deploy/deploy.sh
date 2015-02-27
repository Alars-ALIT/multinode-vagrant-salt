#!/bin/bash

APP_NAME=$1

cd /tmp/apps

sudo docker build -t $APP_NAME - < $APP_NAME.tar.gz
sudo docker save $APP_NAME > $APP_NAME.tar

# Push apps to minions
sudo salt '*' cp.get_dir salt://apps /tmp/apps

# Deploy
sudo salt '*' state.sls app.dynamic

exit 0