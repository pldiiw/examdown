# Examdown

> Write your exam with Markdown + AsciiMath, deliver a PDF

I sometimes need to write documents with equations in it. Word is way too
cumbersome to use. LaTeX is awesome but complex. Why not just use the
simplicity of Markdown syntax and intuitiveness of [AsciiMath] ? That's what
this little bash script provides.

## Install

TODO

## Usage

It is intended to be quite straightforward.

```
$ examdown --help
Markdown + AsciiMath -> PDF

Usage:
  ./examdown [options] <input-file>

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
```

## Contribute

Any suggestion or improvement is welcome!

To work on a new feature, fork, create a new branch, commit and open a PR.  
For the code style, please stick to [Bahamas10' Bash Style Guide] and use
[Shellcheck] as a linter.

## Todo

 - [ ] List dependencies and how to manage them
 - [ ] Build script - make examdown.sh independent of most dependencies

## LICENSE

This repository is under the Unlicense, see LICENSE file for more information.

[AsciiMath]: http://asciimath.org/
[Bahamas10' Bash Style Guide]: https://github.com/bahamas10/bash-style-guide
[Shellcheck]: https://github.com/koalaman/shellcheck
