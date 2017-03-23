#!/usr/bin/env bash

set -e

mkdir -p build/examdown/{bin,lib/examdown}
cp -r src/examdown.sh build/examdown/bin/examdown
cp -r vendor/github-markdown-css/github-markdown.css vendor/MathJax \
  build/examdown/lib/examdown
