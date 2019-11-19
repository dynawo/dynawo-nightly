#!/bin/bash

docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
if [ "$DYNAWO_BUILD_TYPE" = "Debug" -a "$DYNAWO_LIBRARY_TYPE" = "SHARED" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$TESTS_COMMAND"
fi
