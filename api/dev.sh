#!/usr/bin/env bash

DIR=$(realpath ${0%/*})
cd $DIR

if [ ! -d "./localhost.pem" ]; then
  bun x mkcert localhost
fi

exec dev $@
