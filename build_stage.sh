#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  cd dynawo
  util/envDynawo.sh build-3rd-party-version || { echo "Error with build-3rd-party-version."; exit 1; }
  # util/envDynawo.sh build-dynawo || { echo "Error with build-dynawo."; exit 1; }
  util/envDynawo.sh build-dynawo || echo
  cat /Users/travis/build/dynawo/dynawo-nightly/dynawo/build/clang4.2.1/master/Debug-cxx11/shared/dynawo/sources/Models/Modelica/PreassembledModels/GeneratorPV.log
  # if [ "$DYNAWO_BUILD_TYPE" = "Release" ]; then
  #   for job in $(find nrt/data -name "*.jobs"); do
  #     util/envDynawo.sh jobs $job || { echo "Error with job $job."; exit 1; }
  #   done
  # elif [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
  #   util/envDynawo.sh build-tests || { echo "Error with build-tests."; exit 1; }
  # fi
  # $HOME/Dynawo_MacOS_latest/bin/execDynawo.sh jobs $HOME/Dynawo_MacOS_latest/sources/nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/IEEE14.jobs
fi
