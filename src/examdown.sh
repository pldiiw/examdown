#!/bin/bash

ORIGINDIR="$PWD"
cd $(dirname $0)/..
REPODIR="$PWD"
cd $ORIGINDIR

# Defaults
OUTFILE="out.pdf"
TITLE="Exam of $(date)"
CSS="$(cat $REPODIR/lib/github-markdown-css/github-markdown.css)"
AM_SVG_SRC="$REPODIR/lib/MathJax/MathJax.js?config=AM_SVG-full"

parameters="$(getopt -o o:s:t:Oh -l out:,css:,title:,help -n examdown.sh -- $@)"
if [ $? -ne 0 ]; then exit 1; fi # Exit if an argument is incorrect
eval set -- "$parameters"

while true; do
  case "$1" in
    -o|--out)
      OUTFILE=$2; shift 2 ;;
    -s|--css)
      CSS="$(cat $2)"; shift 2 ;;
    -t|--title)
      TITLE=$2; shift 2 ;;
    -h|--help)
      cat << "EOF"
Markdown + AsciiMath -> PDF

Usage:
  ./examdown [options] <input-file>

Options:
  -o, --out <file>    - Save output to <file>
  -O                  - Save output to a file with the same name of
                        the input file - NOT YET IMPLEMENTED
  -s, --css <file>    - Use <file> as the css for the output document
  -t, --title <title> - Set title of document to <title>
  -h, --help          - Display this help notice
EOF
      exit 0 ;;
    --)
      INFILE=$2; shift 2 ;;
    *)
      break ;;
    esac
done

BODY=$(cat $INFILE | $REPODIR/lib/markdown.bash/markdown.sh)

# Mustache templating variables export
export TITLE
export CSS
export AM_SVG_SRC
export BODY

# Render html file
$REPODIR/lib/mo/mo $REPODIR/template/template.html > /tmp/examdown-temp.html
# Convert html file to pdf
wkhtmltopdf --no-stop-slow-scripts --javascript-delay 2000 \
  /tmp/examdown-temp.html $ORIGINDIR/$OUTFILE
# Remove temporary html file
rm -f /tmp/examdown-temp.html
