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
    sed -i '' 's|lldb|lldb -s ~/cmd.gdb|g' /Users/travis/build/dynawo/dynawo-nightly/dynawo/install/clang4.2.1/master/Debug-cxx11/shared/dynawo/bin/launcher
    echo "run" > ~/cmd.gdb
    echo "bt" >> ~/cmd.gdb
    echo "quit" >> ~/cmd.gdb
    util/envDynawo.sh jobs-gdb nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/IEEE14.jobs | tee ~/backtrace
    sed -n -e '(lldb) bt/,$p' ~/backtrace | grep frame | grep -o "at .*" | cut -d ' ' -f 2 | sed 's/:[0-9]*$//' > ~/breakpoints
    sed 's/^/b /g' ~/breakpoints > ~/breakpoints.gdb
    N=$(wc -l ~/breakpoints.gdb | awk '{print $1}')
    echo "run" >> ~/breakpoints.gdb
    for i in `seq 1 $N`; do
      echo "frame variable" >> ~/breakpoints.gdb
      echo "fr v" >> ~/breakpoints.gdb
      echo "continue" >> ~/breakpoints.gdb
    done
    echo "quit" >> ~/breakpoints.gdb
    cat ~/breakpoints.gdb
    sed -i '' 's/cmd.gdb/breakpoints.gdb/' /Users/travis/build/dynawo/dynawo-nightly/dynawo/install/clang4.2.1/master/Debug-cxx11/shared/dynawo/bin/launcher
    cat /Users/travis/build/dynawo/dynawo-nightly/dynawo/install/clang4.2.1/master/Debug-cxx11/shared/dynawo/bin/launcher
    util/envDynawo.sh jobs-gdb nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/IEEE14.jobs
    # tail nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/outputs/logs/dynawo.log
    # tail -50 nrt/data/IEEE14/IEEE14_SyntaxExamples/IEEE14_ModelicaModel/outputs/logs/dynawoCompiler.log
    # echo
    # util/envDynawo.sh jobs nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/IEEE14.jobs || echo "Error"
    # tail nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/outputs/logs/dynawo.log
    # util/envDynawo.sh nrt || { echo "Error with nrt."; exit 1; }
  fi
fi
