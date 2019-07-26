#!/bin/bash


if [[ $# -ne 1 ]]; then
  echo "指定された引数の個数は$#個です" 1>&2
  echo "引数の個数は1個だけです" 1>&2
  exit 1
fi

ARG=$1


path=$ABT"/src/app/build-tools.rb"
ruby $path $ARG
