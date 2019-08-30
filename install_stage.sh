#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker pull dynawo/dynawo-travis
  docker run -itd -u dynawo_travis --name dynawo_travis_container dynawo/dynawo-travis-nightly
  docker exec dynawo_travis_container bash -c "$GIT_COMMAND"
  docker exec dynawo_travis_container bash -c "cd /opt;nohup python -m SimpleHTTPServer 8080 &> /dev/null &"
  docker exec dynawo_travis_container bash -c "$LOG_COMMAND"
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  git clone --depth=1 https://github.com/dynawo/dynawo.git dynawo
  (cd dynawo; git log -1 --decorate)
fi
