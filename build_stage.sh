#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  (cd /opt && curl -L $(curl -s -L -X GET https://api.github.com/repos/dynawo/dynawo/releases/latest | grep "Dynawo_MacOS" | grep url | cut -d '"' -f 4) -o Dynawo_MacOS_latest.zip)
  unzip /opt/Dynawo_MacOS_latest.zip -d /opt/Dynawo_MacOS_latest
  cd dynawo
  util/envDynawo.sh build-3rd-party-version
  util/envDynawo.sh build-dynawo
fi
