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
	./googletest.sh
  zip_url=$(curl -s -L -H "Authorization: token $GITHUB_TOKEN" -X GET https://api.github.com/repos/dynawo/dynawo/releases/latest | grep "Dynawo_MacOS" | grep url | cut -d '"' -f 4)
  curl -L $zip_url -o $HOME/Dynawo_MacOS_latest.zip
  unzip -q $HOME/Dynawo_MacOS_latest.zip -d $HOME/Dynawo_MacOS_latest
  pip install lxml psutil
  brew install --HEAD https://raw.githubusercontent.com/sowson/valgrind/master/valgrind.rb
  BOOST_VERSION=1_69_0
  BOOST_ARCHIVE=boost_${BOOST_VERSION}.tar.gz
  BOOST_DIRECTORY=boost_$BOOST_VERSION
  BOOST_DOWNLOAD_URL=https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION//_/.}
  SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  mkdir -p $SCRIPT_DIR/data
  mkdir -p $SCRIPT_DIR/build
  mkdir -p $SCRIPT_DIR/build-boost
  if [ ! -f "$SCRIPT_DIR/data/$BOOST_ARCHIVE" ]; then
    curl -L $BOOST_DOWNLOAD_URL/$BOOST_ARCHIVE --output $SCRIPT_DIR/data/$BOOST_ARCHIVE || { echo "Error while downloading boost."; exit 1; }
  fi
  if [ ! -d "$SCRIPT_DIR/build/$BOOST_DIRECTORY" ]; then
    tar xzf $SCRIPT_DIR/data/$BOOST_ARCHIVE -C $SCRIPT_DIR/build || { echo "Error while extracting boost."; exit 1; }
  fi
  pushd $SCRIPT_DIR/build/$BOOST_DIRECTORY
  ./bootstrap.sh --prefix=/Users/travis/boost cxxstd=11 --with-toolset=clang --with-libraries=filesystem,program_options,serialization,system,log,iostreams,atomic || { echo "Error while boost bootstrap."; exit 1; }
  ./b2 -d2 --build-dir=$SCRIPT_DIR/build-boost cxxflags="-std=c++11" toolset=clang variant=debug install || { echo "Error while boost b2."; exit 1; }
  for file in `find /Users/travis/boost/lib -name "libboost*.dylib"`; do
    install_name_tool -add_rpath $install_path/lib $file 2> /dev/null || echo -n
  done
fi
