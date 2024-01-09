#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex
source env.sh
if ! command -v sponge &>/dev/null; then
  case $(uname -s) in
  Linux*)
    apt-get install -y moreutils
    ;;
  Darwin*)
    brew install moreutils
    ;;
  esac
fi

export NODE_ENV=production

./svg.var.coffee

cd ..
bun x plugin
bun x vite build
# ./i18n.sh

cd src
if [ -f "../conf/ol.js" ]; then
  cp -f ../conf/ol.js conf.js
fi
cd $DIR
./public.js.sh
# bun x vite build

# cd dist
