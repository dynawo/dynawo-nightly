#!/bin/bash
export DYNAWO_RESULTS_SHOW="false"

export DYNAWO_HOME=/home/dynawo_travis/dynawo;
export DYNAWO_INSTALL_OPENMODELICA=/opt/OpenModelica/Install
export DYNAWO_SRC_OPENMODELICA=/opt/OpenModelica/Source
export DYNAWO_NB_PROCESSORS_USED=$(grep -c \^processor /proc/cpuinfo)
export DYNAWO_ADEPT_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_SUNDIALS_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_SUITE_SPARSE_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_JQUERY_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_FLOT_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_CPPLINT_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_XERCESC_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_BOOST_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_ZLIB_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_LIBARCHIVE_DOWNLOAD_URL=http://localhost:8080
export DYNAWO_PYTHON_COMMAND="python3"
export dynawo_om_env=$(echo -n "-e DYNAWO_INSTALL_OPENMODELICA -e DYNAWO_SRC_OPENMODELICA")
export dynawo_env=$(echo -n "-e DYNAWO_HOME -e DYNAWO_NB_PROCESSORS_USED -e DYNAWO_RESULTS_SHOW -e DYNAWO_BUILD_TYPE -e DYNAWO_CXX11_ENABLED -e DYNAWO_COMPILER -e DYNAWO_LIBRARY_TYPE -e DYNAWO_PYTHON_COMMAND")
export dynawo_env_url=$(echo -n "-e DYNAWO_ADEPT_DOWNLOAD_URL -e DYNAWO_SUNDIALS_DOWNLOAD_URL -e DYNAWO_SUITE_SPARSE_DOWNLOAD_URL -e DYNAWO_JQUERY_DOWNLOAD_URL -e DYNAWO_FLOT_DOWNLOAD_URL -e DYNAWO_CPPLINT_DOWNLOAD_URL -e DYNAWO_XERCESC_DOWNLOAD_URL")
export GIT_COMMAND="git clone --depth=1 https://github.com/dynawo/dynawo.git dynawo"
export LOG_COMMAND="cd dynawo;git log -1 --decorate"
export COMMAND=$(echo -n "cd dynawo;util/envDynawo.sh build-3rd-party;RETURN_CODE=\$?;if [ \${RETURN_CODE} -ne 0 ]; then exit \${RETURN_CODE}; fi;util/envDynawo.sh build-dynawo;")
echo COMMAND $COMMAND
export NRT_COMMAND=$(echo -n "cd dynawo;util/envDynawo.sh nrt;")
echo NRT_COMMAND $NRT_COMMAND
export TESTS_COMMAND=$(echo -n "cd dynawo;util/envDynawo.sh build-tests;")
echo TESTS_COMMAND $TESTS_COMMAND
