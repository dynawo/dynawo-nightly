#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
mkdir -p $SCRIPT_DIR/data
mkdir -p $SCRIPT_DIR/build
mkdir -p $SCRIPT_DIR/build-googletest

GTEST_VERSION=1.8.1
GTEST_ARCHIVE=release-${GTEST_VERSION}.tar.gz
GTEST_DIRECTORY=googletest-release-$GTEST_VERSION
GTEST_DOWNLOAD_URL=https://github.com/google/googletest/archive
if [ ! -f "$SCRIPT_DIR/data/$GTEST_ARCHIVE" ]; then
  curl -L $GTEST_DOWNLOAD_URL/$GTEST_ARCHIVE --output $SCRIPT_DIR/data/$GTEST_ARCHIVE || { echo "Error while downloading GoogleTest."; exit 1; }
fi
if [ ! -d "$SCRIPT_DIR/build/$GTEST_DIRECTORY" ]; then
  tar xzf $SCRIPT_DIR/data/$GTEST_ARCHIVE -C $SCRIPT_DIR/build || { echo "Error while extracting GoogleTest."; exit 1; }
fi

pushd $SCRIPT_DIR/build-googletest
CC=clang CXX=clang++ cmake "$SCRIPT_DIR/build/$GTEST_DIRECTORY" \
	-DBUILD_SHARED_LIBS=ON \
	-DCMAKE_INSTALL_PREFIX=$HOME/googletest \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_MACOSX_RPATH=True \
  -DCMAKE_SKIP_BUILD_RPATH=False \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=False \
  -DCMAKE_INSTALL_RPATH=$HOME/googletest/lib \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=True || { echo "Error while cmake configuration of GoogleTest."; exit 1; }
make || { echo "Error while GoogleTest make."; exit 1; }
make install || { echo "Error while GoogleTest make install."; exit 1; }