#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  cd dynawo
  util/envDynawo.sh build-3rd-party-version || { echo "Error with build-3rd-party-version."; exit 1; }
  util/envDynawo.sh build-dynawo || { echo "Error with build-dynawo."; exit 1; }
  # if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
  #   util/envDynawo.sh build-tests || { echo "Error with build-tests."; exit 1; }
  # fi
  if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
    util/envDynawo.sh jobs nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/IEEE14.jobs || echo "Error"
    tail nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/outputs/logs/dynawo.log
    tail nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/outputs/logs/dynawoCompiler.log
    util/envDynawo.sh jobs nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/IEEE14.jobs || echo "Error"
    # util/envDynawo.sh nrt || { echo "Error with nrt."; exit 1; }
  fi
fi
