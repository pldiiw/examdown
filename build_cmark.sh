#!/usr/bin/env bash

set -e

echo Fetching cmark\'s repo ...
git clone --depth 1 https://github.com/github/cmark.git build/cmark

echo Building cmark ...
mkdir -p build/cmark/build
cd build/cmark/build
cmake ..
make -j9

echo Testing cmark ...
make -j9 test

echo cmark is built at build/cmark/build
echo To install, run: sudo ./install_cmark.sh
