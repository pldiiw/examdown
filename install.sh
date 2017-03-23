#!/usr/bin/env bash

set -e

if [[ $1 ]]; then
  prefix=$1
  mkdir -p "$prefix"
  cp -r build/examdown/* "$prefix"
  chmod 755 "$prefix/bin/examdown"
  chmod -R u=rwX,g=rX,o=rX "$prefix/lib/examdown"
  if [[ $prefix = / || $prefix = /usr || $prefix = /usr/local ]]; then
    chown root:root "$prefix/bin/examdown"
    chown -R root:root "$prefix/lib/examdown"
  fi
else
  echo 'Usage: ./install.sh <prefix>'
  echo 'The prefix is where examdown bin and lib will be copied to.'
  echo 'The default location for such things is /usr/local.'
fi

