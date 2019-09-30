#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
  if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
    docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$TESTS_COMMAND"
  fi
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  cd dynawo
  util/envDynawo.sh build-3rd-party-version || { echo "Error with build-3rd-party-version."; exit 1; }
  util/envDynawo.sh build-dynawo || { echo "Error with build-dynawo."; exit 1; }
  if [ "$DYNAWO_BUILD_TYPE" = "Release" ]; then
    for job in $(find nrt/data -name "*.jobs"); do
      util/envDynawo.sh jobs $job || { echo "Error with job $job."; exit 1; }
    done
  elif [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
    util/envDynawo.sh build-tests || { echo "Error with build-tests."; exit 1; }
  fi
fi
