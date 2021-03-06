#!/bin/bash
export DYNAWO_RESULTS_SHOW="false"

export DYNAWO_HOME=$(pwd)/dynawo
export DYNAWO_INSTALL_OPENMODELICA=$HOME/Dynawo_MacOS_latest/dynawo/OpenModelica
export DYNAWO_SRC_OPENMODELICA=$DYNAWO_HOME/OpenModelica/Source
# export DYNAWO_NB_PROCESSORS_USED=$(sysctl hw | grep ncpu | awk '{print $(NF)}')
export DYNAWO_NB_PROCESSORS_USED=1

export MACOSX_DEPLOYMENT_TARGET=10.14
export DYNAWO_BOOST_HOME_DEFAULT=false
