#!/usr/bin/env bash

DIR=$(realpath ${0%/*})
cd $DIR

if ! command -v open &>/dev/null; then
  if [ ! -d "./localhost.pem" ]; then
    bun x mkcert localhost
  fi
  export HTTPS=1
fi

exec dev $@
