#!/usr/bin/env bash

set -e

short='o:s:t:Oh'
long='out:,css:,title:,help'
parsed=$(getopt -o "$short" -l "$long" -n "$0" -- "$@")
if [ $? -ne 0 ]; then exit 1; fi # If getopt fucked up
eval set -- "$parsed"

while true; do
  case "$1" in
    -o|--out)
      out="$2"
      shift 2
      ;;
    -O)
      bigo_option='y'
      shift
      ;;
    -s|--css)
      css="$2"
      shift 2
      ;;
    -t|--title)
      title="$2"
      shift 2
      ;;
    -h|--help)
      cat << "EOF"
Markdown + AsciiMath -> PDF

Usage:
  ./examdown [options] <input-file>

Options:
  -o, --out <file>    - Save output to <file>
  -O                  - Save output to a file with the same name and
                        in the same directory as the input file
  -s, --css <file>    - Use <file> as the css for the output document
  -t, --title <title> - Set title of document to <title>
  -h, --help          - Display this help notice
EOF
      exit 0
      ;;
    --)
      in="$2"
      break
      ;;
    *)
      echo "Unrecognized option: $1"
      exit 1
      ;;
    esac
done

origindir="$PWD"
repodir="${0%/*/*}"
out="${out:-${bigo_option:+${in%.*}.pdf}}"
title="${title:-Exam of $(date)}"
css="${css:-$repodir/lib/github-markdown-css/github-markdown.css}"
am_svg="$repodir/lib/MathJax/MathJax.js?config=AM_SVG-full"
body="$("$repodir"/lib/markdown.bash/markdown.sh "$in")"

# Mustache templating variables export
export title
export css
export am_svg
export body

# Render html file
"$repodir"/lib/mo/mo "$repodir"/template/template.html > \
  examdown-temp.html
# Convert html file to pdf
wkhtmltopdf --no-stop-slow-scripts --javascript-delay 3000 \
  examdown-temp.html "$origindir/${out:-out.pdf}"
# Remove temporary html file
rm -f examdown-temp.html
