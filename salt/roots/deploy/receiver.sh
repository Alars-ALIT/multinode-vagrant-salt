#!/bin/bash
set -e
echo $(groups)

APP=$1
REVISION=$2
USER=$3

echo "----> Unpacking repo..."
sudo mkdir -p /tmp/build/$APP && cat | sudo tar -x -C /tmp/build/$APP

# Build
echo "----> Building $APP"
sudo docker run -e APP_NAME=$APP -v /tmp/build/$APP:/tmp/build alars/go-builder 
sudo docker build -t $APP /tmp/build/$APP/
sudo docker save $APP > /tmp/deploy/$APP.tar

# Push apps to minions
echo "----> Push $APP to minions"
sudo salt '*' cp.get_file salt://deploy/$APP.tar /tmp/deploy/$APP.tar

# Deploy
echo "----> Deploying $APP on minions"
sudo salt 'minion-*' state.sls app.dynamic

exit 0