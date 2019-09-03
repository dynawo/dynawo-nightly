#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  cd dynawo
  util/envDynawo.sh build-3rd-party-version || { echo "Error with build-3rd-party-version."; exit 1; }
  util/envDynawo.sh build-dynawo || echo
  if [ "$DYNAWO_BUILD_TYPE" = "Release" -a "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
    cat /Users/travis/build/dynawo/dynawo-nightly/dynawo/build/clang4.2.1/master/Release-cxx11/shared/dynawo/sources/Models/Modelica/PreassembledModels/UnderVoltageAutomaton.log
  fi
fi
