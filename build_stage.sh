#!/bin/bash

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$COMMAND"
  docker exec $dynawo_env $dynawo_om_env $dynawo_env_url dynawo_travis_container bash -c "$NRT_COMMAND"
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  cd dynawo
  #export DYNAWO_DEBUG_COMPILER_OPTION="-O1 -fsanitize=address -fno-omit-frame-pointer"
  util/envDynawo.sh build-3rd-party-version || { echo "Error with build-3rd-party-version."; exit 1; }
  sed -i '' 's/-O1/-O1 -fsanitize=address -fno-omit-frame-pointer/' util/envDynawo.sh
  sed -i '' 's/$DYNAWO_DEBUG_COMPILER_OPTION/"$DYNAWO_DEBUG_COMPILER_OPTION"/' util/envDynawo.sh
  util/envDynawo.sh build-dynawo || { echo "Error with build-dynawo."; exit 1; }
  for job in $(find nrt/data -name "*.jobs"); do
    util/envDynawo.sh jobs $job || { echo "Error with job $job."; exit 1; }
  done
  # if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
  #   util/envDynawo.sh build-tests || { echo "Error with build-tests."; exit 1; }
  # fi
  # if [ "$DYNAWO_BUILD_TYPE" = "Debug" ]; then
  #   sed -i '' 's|lldb|lldb -s ~/cmd.gdb|g' /Users/travis/build/dynawo/dynawo-nightly/dynawo/install/clang4.2.1/master/Debug-cxx11/shared/dynawo/bin/launcher
  #   echo "run" > ~/cmd.gdb
  #   echo "bt" >> ~/cmd.gdb
  #   echo "frame variable" >> ~/cmd.gdb
  #   echo "fr v" >> ~/cmd.gdb
  #   echo "quit" >> ~/cmd.gdb
  #   #util/envDynawo.sh jobs-gdb nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/IEEE14.jobs 2>&1 | tee ~/backtrace
  #   #cat nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/logs/dynawo.log
  #   #util/envDynawo.sh jobs-gdb nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/IEEE14.jobs
  #   #cat nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/logs/dynawo.log
  #   echo "==============================================================="
  #   echo "cat Models"
  #   cat  build/clang4.2.1/master/Debug-cxx11/shared/dynawo/sources/Models/Modelica/PreassembledModels/GeneratorSynchronousFourWindingsProportionalRegulations.h
  #   cat  build/clang4.2.1/master/Debug-cxx11/shared/dynawo/sources/Models/Modelica/PreassembledModels/GeneratorSynchronousFourWindingsProportionalRegulations.cpp
  #   cat  build/clang4.2.1/master/Debug-cxx11/shared/dynawo/sources/Models/Modelica/PreassembledModels/GeneratorSynchronousFourWindingsProportionalRegulations_Init.h
  #   cat  build/clang4.2.1/master/Debug-cxx11/shared/dynawo/sources/Models/Modelica/PreassembledModels/GeneratorSynchronousFourWindingsProportionalRegulations_Dyn.h
  #   echo "==============================================================="
  #   util/envDynawo.sh jobs nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/IEEE14.jobs
  #   echo "==============================================================="
  #   echo "ENV"
  #   env
  #   echo "==============================================================="
  #   #travis_wait util/envDynawo.sh jobs-valgrind nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/IEEE14.jobs
  #   util/envDynawo.sh jobs-gdb nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/IEEE14.jobs > ~/backtrace
  #   echo "==============================================================="
  #   echo "cat dynawo.log"
  #   cat nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/logs/dynawo.log
  #   echo "==============================================================="
  #   #util/envDynawo.sh jobs-gdb nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/IEEE14.jobs 2>&1 | tee ~/backtrace2
  #   #util/envDynawo.sh dump-model nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/compilation/GEN____1_SM.dylib -o ~/dump.xml
  #   echo "==============================================================="
  #   echo "cat dump.xml"
  #   cat ~/dump.xml
  #   echo "==============================================================="
  #   #ls nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/compilation
  #   echo "==============================================================="
  #   echo "cat backtrace"
  #   cat ~/backtrace
  #   echo "==============================================================="
  #   sed -n -e '/(lldb) bt/,$p' ~/backtrace | grep frame | grep -o "at .*" | cut -d ' ' -f 2 | sed 's/:[0-9]*$//' > ~/breakpoints
  #   sed -i '' '/main.cpp/d' ~/breakpoints
  #   #echo "cat breakpoints"
  #   #cat ~/breakpoints
  #   sed 's/^/b /g' ~/breakpoints > ~/breakpoints.gdb
  #   #echo "cat breakpoints.gdb"
  #   #cat ~/breakpoints.gdb
  #   echo "run" >> ~/breakpoints.gdb
  #   N=$(wc -l ~/breakpoints.gdb | awk '{print $1}')
  #   for i in `seq 1 100`; do
  #     #echo "breakpoint command add $i" >> ~/breakpoints.gdb
  #     echo "frame variable" >> ~/breakpoints.gdb
  #     echo "fr v" >> ~/breakpoints.gdb
  #     echo "continue" >> ~/breakpoints.gdb
  #     #echo "DONE" >> ~/breakpoints.gdb
  #   done
  #   #echo "breakpoint list" >> ~/breakpoints.gdb
  #   #echo "run" >> ~/breakpoints.gdb
  #   #echo "continue" >> ~/breakpoints.gdb
  #   echo "quit" >> ~/breakpoints.gdb
  #   echo "==============================================================="
  #   echo "cat breakpoints.gdb"
  #   cat ~/breakpoints.gdb
  #   echo "==============================================================="
  #   #cat ~/breakpoints.gdb
  #   sed -i '' 's/cmd.gdb/breakpoints.gdb/' /Users/travis/build/dynawo/dynawo-nightly/dynawo/install/clang4.2.1/master/Debug-cxx11/shared/dynawo/bin/launcher
  #   util/envDynawo.sh jobs-gdb nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/IEEE14.jobs
  #   echo "==============================================================="
  #   echo "cat dynawo.log"
  #   cat nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/logs/dynawo.log
  #   echo "==============================================================="
  #   # tail nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/logs/dynawo.log
  #   # tail -50 nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/outputs/logs/dynawoCompiler.log
  #   # echo
  #   # util/envDynawo.sh jobs nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/IEEE14.jobs || echo "Error"
  #   # tail nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/outputs/logs/dynawo.log
  #   # util/envDynawo.sh nrt || { echo "Error with nrt."; exit 1; }
  #   # $HOME/Dynawo_MacOS_latest/bin/execDynawo.sh jobs nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/IEEE14.jobs || echo
  #   # echo
  #   # $HOME/Dynawo_MacOS_latest/bin/execDynawo.sh jobs $HOME/Dynawo_MacOS_latest/sources/nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectGroup/IEEE14.jobs || echo
  #   # echo
  #   # $HOME/Dynawo_MacOS_latest/bin/execDynawo.sh jobs nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_LoadVariation/IEEE14.jobs || echo
  #   # echo
  # fi
fi
