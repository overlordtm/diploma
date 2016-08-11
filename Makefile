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

debug: clean
	$(LATEX) $(LATEXOPT) $(MAIN)
	$(MAKE) check

clean:
	$(LATEXMK) $(LATEXMKOPT) -C $(MAIN)

.github-release-installed:
	touch .github-release-installed
	go get github.com/aktau/github-release

github-release: .github-release-installed

release: once github-release
	TAG=`date "+%Y-%m-%d"`; \
	TAG2=`date "+%Y-%m-%d-%H-%M"`; \
	NAME="diploma-$$TAG2.pdf"; \
	OPTS="--tag $$TAG --name $$NAME"; \
	github-release release $$OPTS --pre-release || github-release edit $$OPTS --pre-release; \
	github-release upload $$OPTS --file ./$(OUTDIR)/diploma.pdf

.PHONY: clean force debug once all github-release
