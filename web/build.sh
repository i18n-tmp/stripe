#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

cd src

if [ -f "../conf/ol.js" ]; then
  cp -f ../conf/ol.js conf.js
fi

cd ..

direnv exec . ./sh/build.sh

if [ -f "../conf/ol.js" ]; then
  rm src/conf.js
fi
