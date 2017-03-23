#!/usr/bin/env bash

set -e

examdown_location="$(whereis examdown | cut -d ' ' -f 2)"
prefix="${examdown_location%/*/*}"
rm -f "$prefix/bin/examdown"
rm -rf "$prefix/lib/examdown"
rmdir "$prefix"/{bin,lib} || true
echo Uninstalled!
