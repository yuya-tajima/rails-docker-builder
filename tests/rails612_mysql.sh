#!/usr/bin/env zsh

set -u

autoload -Uz catch
autoload -Uz throw

DIR=$(dirname $0)

./build.sh 6.1.2 mysql
source ${DIR}/inc.sh

RET=$?

if [[ $RET -eq 0 ]]; then
  ./clean.sh > /dev/null 2>&1
else
  echo "ERROR: CODE:$RET"
  exit 2
fi
