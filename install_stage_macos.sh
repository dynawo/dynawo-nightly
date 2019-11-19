#!/bin/bash

git clone --depth=1 https://github.com/dynawo/dynawo.git dynawo
(cd dynawo; git log -1 --decorate)
zip_url=$(curl -s -L -H "Authorization: token $GITHUB_TOKEN" -X GET https://api.github.com/repos/dynawo/dynawo/releases/latest | grep "Dynawo_MacOS" | grep url | cut -d '"' -f 4)
curl -L $zip_url -o $HOME/Dynawo_MacOS_latest.zip
unzip -q $HOME/Dynawo_MacOS_latest.zip -d $HOME/Dynawo_MacOS_latest
(cd $HOME/Dynawo_MacOS_latest;rm -rf ddb sbin bin share sources)
(cd $HOME/Dynawo_MacOS_latest/include;rm -rf CRV* CSTR* DYD* DYN* EXTVAR* JOB* PAR* TL* FS* IIDM SuiteSparse_config.h adept adept.h adept_arrays.h amd.h btf.h colamd.h config.h gtest_dynawo.h ida kinsol klu.h libzip nvector sundials sunlinsol sunmatrix sunnonlinsol xercesc xml zconf.h zlib.h)
(cd $HOME/Dynawo_MacOS_latest/lib;rm -f libdynawo* libiidm* libsundials* libxerces-c* libzip* libklu* libamd* libcolamd* libbtf* libXML* libadept* libz* libsuitesparseconfig*)
pip install lxml psutil
echo "[install]
prefix=" > ~/.pydistutils.cfg
