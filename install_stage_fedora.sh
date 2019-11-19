#!/bin/bash

docker run -itd -u dynawo_travis --name dynawo_travis_container dynawo/dynawo-travis-nightly-fedora
docker exec dynawo_travis_container bash -c "$GIT_COMMAND"
docker exec dynawo_travis_container bash -c "cd /opt;nohup python -m SimpleHTTPServer 8080 &> /dev/null &"
docker exec dynawo_travis_container bash -c "$LOG_COMMAND"
