#!/usr/bin/env bash

set -e

mkdir -p build/cmark
cd build/cmark

echo Fetching cmark\'s repo ...
git clone --depth 1 https://github.com/github/cmark.git /tmp/cmark

echo Building cmark ...
cmake /tmp/cmark
make -j9

echo Testing cmark ...
make -j9 test

echo Removing repo ...
rm -rf /tmp/cmark

echo cmark is built at build/cmark
echo To install, run: sudo ./install_cmark.sh
