#!/bin/bash

function stop() {
  pid=$(ps -a | grep "ruby" | grep "build-tool.rb")
  pid=${pid:0:5}
  read && kill $pid && exit 0
}

if [[ $# -ne 1 ]]; then
  echo "指定された引数の個数は$#個です" 1>&2
  echo "引数の個数は1個だけです" 1>&2
  exit 1
fi

ARG=$1

case $ARG in
  "~test" ) ruby "/Users/ikemorikaduki/Documents/Myprograming/atcoder-tools/app/build-tool.rb" $ARG & stop
    ;;
  * ) ruby "/Users/ikemorikaduki/Documents/Myprograming/atcoder-tools/app/build-tool.rb" $ARG 
esac
