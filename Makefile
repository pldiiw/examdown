.PHONY: build install uninstall build-cmark install-cmark checkdeps test clean clean-tests

PREFIX=/usr/local

build:
	mkdir -p build/examdown/bin build/examdown/lib/examdown
	cp -r src/examdown.sh build/examdown/bin/examdown
	cp -r vendor/github-markdown-css/github-markdown.css vendor/MathJax build/examdown/lib/examdown

install:
	mkdir -p "$(PREFIX)"
	cp -r build/examdown/* "$(PREFIX)"
	chmod 755 "$(PREFIX)/bin/examdown"
	chmod -R u=rwX,g=rX,o=rX "$(PREFIX)/lib/examdown"

uninstall:
	rm -f "$(PREFIX)/bin/examdown"
	rm -rf "$(PREFIX)/lib/examdown"
	rmdir "$(PREFIX)/bin" "$(PREFIX)/lib" || true

#FIXME: Do not use .ONESHELL special target please
.ONESHELL:
build-cmark:
	echo "Cloning cmark's repo ..."
	git clone --depth 1 https://github.com/github/cmark.git build/cmark

	echo 'Building cmark ...'
	mkdir -p build/cmark/build
	cd build/cmark/build
	cmake ..
	make -j9

	echo 'Testing cmark ...'
	make -j9 test

	echo 'cmark has been built at build/cmark/build'

install-cmark:
	make -C build/cmark/build install

checkdeps:
	getopt --version
	cmark --version | head -n 1
	wkhtmltopdf --version
	ls vendor/github-markdown-css/github-markdown.css
	ls vendor/MathJax/MathJax.js

clean: clean-tests
	rm -rf build

clean-tests:
	rm -f test/*.pdf

test:
	./build/examdown/bin/examdown -O test/test.md
	xdg-open test/test.pdf
