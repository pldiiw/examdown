#!/usr/bin/env bash

set -e

echo Installing cmark ...
cd build/cmark/build
make install
