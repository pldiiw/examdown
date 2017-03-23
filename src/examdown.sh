#!/usr/bin/env bash

set -e

short='o:s:t:d:Oh'
long='out:,css:,title:,delay:,help'
parsed=$(getopt -o "$short" -l "$long" -n "$0" -- "$@")
if [[ $? -ne 0 ]]; then exit 1; fi # If getopt fucked up
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
    -d|--delay)
      delay="$2"
      shift 2
      ;;
    -h|--help)
      cat << "EOF"
Markdown + AsciiMath -> PDF

Usage:
  examdown [options] <input-file>

Options:
  -o, --out <file>    - Save output to <file>. Defaults to 'out.pdf'.
  -O                  - Save output to a file with the same name and
                        in the same directory as the input file.
  -s, --css <file>    - Use <file> as the CSS for the output document.
                        If unspecified, will use a built-in CSS file.
  -t, --title <title> - Set title of document to <title>.
  -d, --delay <ms>    - Wait specified amount of milliseconds for the
                        javascript to render the math equations.
                        Defaults to 3000.
  -h, --help          - Display this help notice.
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
prefix="${0%/*/*}"
out="${out:-${bigo_option:+${in%.*}.pdf}}"
title="${title:-Exam of $(date)}"
css="${css:-$prefix/lib/examdown/github-markdown.css}"
am_svg="$prefix/lib/examdown/MathJax/MathJax.js?config=AM_SVG-full"
body="$(cmark -e table -e strikethrough -e autolink --smart -t html "$in")"

cat <<EOF > examdown-temp.html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>$title</title>
  <link rel="stylesheet" href="$css" />
  <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      asciimath2jax: {
        delimiters: [ [ '$', '$' ] ]
      }
    });
  </script>
  <script src="$am_svg"></script>
</head>
<body class="markdown-body">
  $body
</body>
</html>
EOF

# Convert html file to pdf
wkhtmltopdf --no-stop-slow-scripts --javascript-delay "${delay:-3000}" \
  examdown-temp.html "$origindir/${out:-out.pdf}"
# Remove temporary html file
rm -f examdown-temp.html
