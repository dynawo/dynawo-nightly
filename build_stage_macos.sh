#!/bin/bash

if [ "$DYNAWO_BUILD_TYPE" = "Release" ]; then
  for job in $(find nrt/data -name "*.jobs"); do
    util/envDynawo.sh jobs $job || { echo "Error with job $job."; exit 1; }
  done
elif [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
  util/envDynawo.sh build-tests || { echo "Error with build-tests."; exit 1; }
fi
