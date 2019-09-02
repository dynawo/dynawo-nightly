#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  zip_file=$(curl -s -L -X GET https://api.github.com/repos/dynawo/dynawo/releases/latest | grep "Dynawo_MacOS" | grep url | cut -d '"' -f 4)
  curl -s -L -X GET https://api.github.com/repos/dynawo/dynawo/releases/latest
  echo zip_file $zip_file
  (cd /opt && curl -L $zip_file -o Dynawo_MacOS_latest.zip)
  unzip /opt/Dynawo_MacOS_latest.zip -d /opt/Dynawo_MacOS_latest
  cd dynawo
  ls /opt/Dynawo_MacOS_latest/lib
  ls /opt/Dynawo_MacOS_latest/include
  util/envDynawo.sh build-3rd-party-version || { echo "Error with build-3rd-party-version."; exit 1; }
  util/envDynawo.sh build-dynawo || { echo "Error with build-dynawo."; exit 1; }
fi
