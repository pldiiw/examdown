#!/bin/bash

ORIGINDIR="$PWD"
cd $(dirname $0)

parameters="$(getopt -o o:s:t:Oh -l out:,css:,title:,help -n examdown.sh -- $@)"
if [ $? -ne 0 ]; then exit 1; fi # Exit if an argument is incorrect
echo $parameters
eval set -- "$parameters"

# Defaults
OUTFILE="out.html"
TITLE="Exam of $(date)"
CSS="$(cat ../lib/github.css)"

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
Parameters:
-o --out <file>    Save output to <file>
-O                 Save output to a file with the same name of the input file
-s --css <file>    Use <file> as the css for the output document
-t --title <title> Set title of document to <title>
-h --help          Display this help notice
EOF
      exit 0 ;;
    --)
      INFILE=$2; shift 2 ;;
    *)
      break ;;
    esac
done

# Mustache templating variables export
export TITLE
export CSS
export ASCIIMATHMLJS="$(cat ../lib/ASCIIMathML.js)"
export BODY="$(cat $ORIGINDIR/$INFILE | ../lib/markdown.sh)" # Markdown is converted to
                                                  # html here

../lib/mo ../template/template.html > $ORIGINDIR/$OUTFILE # Render html file
