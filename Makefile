ALVER := $(shell awk '/ProvidesPackage\{algorithmlite\}/{getline; match($$0, /v[0-9.]+/); print substr($$0, RSTART, RLENGTH)}' algorithmlite.sty)

DOCS := algorithmlite.pdf

.PHONY: ctanzip
ctanzip: algorithmlite.zip ## Archive for CTAN upload
algorithmlite.zip: clean $(DOCS)
	git archive --format=tar --prefix=algorithmlite/ HEAD | gtar -x
	## remove unpacked files
	cd algorithmlite/ && \
		rm -f .gitignore Makefile ctan.toml
	## then, now just make archive
	zip -9 -r algorithmlite.zip algorithmlite/*
	rm -rf algorithmlite
	@echo finished

.PHONY: algorithmlite.pdf
algorithmlite.pdf: algorithmlite.tex algorithmlite.sty
	pdflatex -interaction=nonstopmode -halt-on-error $<
	pdflatex -interaction=nonstopmode -halt-on-error $<

## Run the test suite ($(ALVER)):
##  * every test is compiled twice (for \ref and \listofalgorithms;
##    test-tagging-*: three times, for the structure tree) without
##    errors
##  * ALGL-RESULT OK and no ALGL-* NG (see test-common.tex)
##  * no LaTeX warning other than "Label(s) may have changed" (and the
##    one of tagpdf on unicode-math with lualatex)
##  * test-hyperref-*, test-tagging-hyperref-*: no warning on a
##    duplicate or missing destination in the log or in the output of
##    the engine and (x)dvipdfmx
##  * test-errors-*: the expected error message
## A test is "<engine>:<jobname>:<input>".  The output of the engine and
## of (x)dvipdfmx is kept in <jobname>.term.
JA := \def\WANTJA{1}
TESTS := \
  pdflatex:test-basic-pdflatex:'\input test-basic' \
  pdflatex:test-basic-book-pdflatex:'\def\CLS{book}\input test-basic' \
  xelatex:test-basic-xelatex:'\input test-basic' \
  xelatex:test-basic-book-xelatex:'\def\CLS{book}\input test-basic' \
  lualatex:test-basic-lualatex:'\input test-basic' \
  lualatex:test-basic-book-lualatex:'\def\CLS{book}\input test-basic' \
  lualatex:test-basic-luatexja-lualatex:'\def\ALGLafter{\usepackage{luatexja}}$(JA)\input test-basic' \
  lualatex:test-basic-ltjsarticle-lualatex:'\def\CLS{ltjsarticle}$(JA)\def\WANTSEP{\nobreak}\input test-basic' \
  lualatex:test-basic-ltjsbook-lualatex:'\def\CLS{ltjsbook}$(JA)\def\WANTSEP{\nobreak}\input test-basic' \
  lualatex:test-basic-ltjsarticle-english-lualatex:'\def\CLS{ltjsarticle}\def\CLSOPT{english}\input test-basic' \
  lualatex:test-basic-jlreq-book-lualatex:'\def\CLS{jlreq}\def\CLSOPT{book}$(JA)\def\WANTSEP{}\input test-basic' \
  platex:test-basic-jarticle-platex:'\def\CLS{jarticle}$(JA)\def\WANTSEP{~}\input test-basic' \
  platex:test-basic-jsbook-platex:'\def\CLS{jsbook}$(JA)\def\WANTSEP{\nobreak}\input test-basic' \
  platex:test-basic-jsbook-english-platex:'\def\CLS{jsbook}\def\CLSOPT{english}\input test-basic' \
  uplatex:test-basic-ujarticle-uplatex:'\def\CLS{ujarticle}$(JA)\def\WANTSEP{~}\input test-basic' \
  uplatex:test-basic-ujbook-uplatex:'\def\CLS{ujbook}$(JA)\def\WANTSEP{~}\input test-basic' \
  uplatex:test-basic-jlreq-uplatex:'\def\CLS{jlreq}$(JA)\def\WANTSEP{}\input test-basic' \
  pdflatex:test-hyperref-pdflatex:'\def\CLS{book}\input test-hyperref' \
  xelatex:test-hyperref-xelatex:'\def\CLS{book}\input test-hyperref' \
  lualatex:test-hyperref-lualatex:'\def\CLS{ltjsbook}$(JA)\def\WANTSEP{\nobreak}\input test-hyperref' \
  platex:test-hyperref-platex:'\def\CLS{jsbook}$(JA)\def\WANTSEP{\nobreak}\input test-hyperref' \
  uplatex:test-hyperref-uplatex:'\def\CLS{ujbook}$(JA)\def\WANTSEP{~}\input test-hyperref' \
  pdflatex:test-twocolumn-pdflatex:'\input test-twocolumn' \
  uplatex:test-twocolumn-uplatex:'\def\CLS{ujarticle}$(JA)\def\WANTSEP{~}\input test-twocolumn' \
  pdflatex:test-compat-floatbefore:'\def\CASE{floatbefore}\input test-compat' \
  pdflatex:test-compat-floatafter:'\def\CASE{floatafter}\input test-compat' \
  pdflatex:test-compat-newfloat:'\def\CASE{newfloat}\input test-compat' \
  pdflatex:test-compat-caption:'\def\CASE{caption}\input test-compat' \
  pdflatex:test-compat-memoir:'\def\CASE{memoir}\input test-compat' \
  pdflatex:test-tagging-pdflatex:'\input test-tagging' \
  pdflatex:test-tagging-book-pdflatex:'\def\CLS{book}\input test-tagging' \
  pdflatex:test-tagging-hyperref-pdflatex:'\def\CLS{book}\def\ALGLhyperref{}\input test-tagging' \
  pdflatex:test-tagging-twocolumn-pdflatex:'\def\ALGLtwocolumn{}\input test-tagging' \
  pdflatex:test-tagging-setup-pdflatex:'\def\ALGLafter{\tagpdfsetup{float/new=algorithm}}\input test-tagging' \
  lualatex:test-tagging-lualatex:'\input test-tagging' \
  lualatex:test-tagging-ltjsbook-lualatex:'\def\CLS{ltjsbook}$(JA)\def\WANTSEP{\nobreak}\input test-tagging'

## "<case>:<error message>" of test-errors.tex (pdflatex)
ERRORS := \
  algbefore:"Package .algorithm. cannot be used" \
  algafter:"Package .algorithm. cannot be used" \
  alg2e:"Package .algorithm2e. cannot be used" \
  alg2eafter:"Package .algorithm2e. cannot be used" \
  defined:"is already defined"

.PHONY: test
test:
	@set -e; \
	for t in $(TESTS); do \
	  eng=$${t%%:*}; rest=$${t#*:}; job=$${rest%%:*}; in=$${rest#*:}; \
	  echo "== $$eng $$job"; \
	  rm -f $$job.aux $$job.loa $$job.dvi $$job.xdv; \
	  opt=; if [ $$eng = xelatex ]; then opt=-no-pdf; fi; \
	  runs="1 2"; case $$job in test-tagging-*) runs="1 2 3";; esac; \
	  for i in $$runs; do \
	    $$eng $$opt -interaction=nonstopmode -jobname=$$job "$$in" >$$job.term 2>&1 || true; \
	  done; \
	  if [ -f $$job.dvi ]; then dvipdfmx $$job.dvi >>$$job.term 2>&1; fi; \
	  if [ -f $$job.xdv ]; then xdvipdfmx $$job.xdv >>$$job.term 2>&1; fi; \
	  if grep -q '^!' $$job.log; then echo "NG: error in $$job.log"; exit 1; fi; \
	  if grep -q '^ALGL-.* NG' $$job.log; then grep '^ALGL-.* NG' $$job.log; exit 1; fi; \
	  grep -q '^ALGL-RESULT OK' $$job.log || \
	    { echo "NG: no ALGL-RESULT OK in $$job.log"; exit 1; }; \
	  if grep 'LaTeX Warning\|Package .* Warning' $$job.log | \
	    grep -v 'Label(s) may have changed' | \
	    grep -v 'Neither unicode-math nor lua-unicode-math'; then \
	    echo "NG: warning in $$job.log"; exit 1; fi; \
	  case $$job in test-hyperref-*|test-tagging-hyperref-*) \
	    if cat $$job.log $$job.term | \
	      grep -i 'duplicate\|already defined\|does not exist\|unreferenced destination' | \
	      grep -v '^Info: mathml file'; then \
	      echo "NG: destination warning in $$job.log or $$job.term"; exit 1; fi;; \
	  esac; \
	done; \
	for e in $(ERRORS); do \
	  c=$${e%%:*}; msg=$${e#*:}; job=test-errors-$$c; \
	  echo "== pdflatex $$job"; \
	  pdflatex -interaction=nonstopmode -jobname=$$job "\def\CASE{$$c}\input test-errors" >$$job.term 2>&1 || true; \
	  grep -q "^! Package algorithmlite Error: .*$$msg" $$job.log || \
	    { echo "NG: no expected error in $$job.log"; exit 1; }; \
	done; \
	echo "All tests passed ($(ALVER))"

.PHONY: clean
clean: ## Clean this repository
	rm -rf algorithmlite.zip algorithmlite
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.loa *.lop *.dvi *.xdv *.synctex.gz *.term
	rm -f test-*.pdf
	find . -type f -name "*~" -delete
