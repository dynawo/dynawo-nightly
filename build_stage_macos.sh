#!/bin/bash

cd dynawo
util/envDynawo.sh build-3rd-party || { echo "Error with build-3rd-party."; exit 1; }
travis_wait 30 util/envDynawo.sh build-dynawo || { echo "Error with build-dynawo."; exit 1; }
if [ "$DYNAWO_BUILD_TYPE" = "Release" ]; then
  for job in $(find nrt/data -name "*.jobs"); do
    util/envDynawo.sh jobs $job || { echo "Error with job $job."; exit 1; }
  done
elif [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
  util/envDynawo.sh build-tests || { echo "Error with build-tests."; exit 1; }
fi
