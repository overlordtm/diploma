LATEX=pdflatex
LATEXOPT=--shell-escape -recorder
NONSTOP=--interaction=batchmode

MAIN=diploma
OUTDIR=out
AUXDIR=aux
SOURCES=$(MAIN).tex Makefile

LATEXMK=latexmk
LATEXMKOPT=-pdf -cd -bibtex -outdir=$(OUTDIR)
CONTINUOUS=-pvc

export openout_any=a

all: $(OUTDIR)/$(MAIN).pdf

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(MAIN).pdf: $(OUTDIR)/$(MAIN).pdf
	ln -sf out/diploma.pdf diploma.pdf

$(OUTDIR)/$(MAIN).pdf: $(MAIN).tex $(OUTDIR)
	$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) \
		-pdflatex="$(LATEX) $(LATEXOPT) $(NONSTOP) %O %S" $(MAIN)

force: clean $(OUTDIR)
	$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) \
		-pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

once: $(MAIN).tex
	$(LATEXMK) $(LATEXMKOPT) \
		-pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

check:
	chktex $(MAIN)

glossaries:
	makeglossaries -d out $(MAIN)

spell-check:
	@ hunspell -l -t -i utf-8 -d sl_SI,en_US $(MAIN).tex 2>/dev/null

debug: clean $(OUTDIR)
	$(LATEX) -output-directory=$(OUTDIR) $(LATEXOPT) $(MAIN)
	$(MAKE) check

clean:
	$(LATEXMK) -outdir=$(OUTDIR) -C $(MAIN)

.github-release-installed:
	touch .github-release-installed
	go get github.com/aktau/github-release

github-release: .github-release-installed

release: once github-release
	. ./secrets; \
	TAG=`date "+%Y-%m-%d"`; \
	TAG2=`date "+%Y-%m-%d-%H-%M"`; \
	NAME="diploma-$$TAG2.pdf"; \
	OPTS="--tag $$TAG --name $$NAME"; \
	github-release release $$OPTS --pre-release || github-release edit $$OPTS --pre-release; \
	github-release upload $$OPTS --file ./$(OUTDIR)/diploma.pdf

.PHONY: clean force debug once all github-release
