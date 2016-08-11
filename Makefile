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

all: $(MAIN).pdf

$(OUTDIR)/.refresh:
	mkdir -p $(OUTDIR)
	touch $(OUTDIR)/.refresh

$(MAIN).pdf: $(MAIN).tex $(OUTDIR)/.refresh
	$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) \
		-pdflatex="$(LATEX) $(LATEXOPT) $(NONSTOP) %O %S" $(MAIN)

debug:
force:
	mkdir -p $(OUTDIR)
	touch $(OUTDIR)/.refresh
	rm -f $(OUTDIR)/$(MAIN).pdf
	$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) \
		-pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

clean:
	$(LATEXMK) $(LATEXMKOPT) -C $(MAIN)

once: $(MAIN).tex $(OUTDIR)/.refresh
	$(LATEXMK) $(LATEXMKOPT) \
		-pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

check:
	chktex $(MAIN)

debug:
	$(LATEX) $(LATEXOPT) $(MAIN)

.deps:
	touch .deps

github-release: .deps
	go get github.com/aktau/github-release

release: $(MAIN).tex $(OUTDIR)/.refresh github-release
	TAG=`date "+%Y-%m-%d"`; \
	TAG2=`date "+%Y-%m-%d-%H-%M"`; \
	NAME="diploma-$$TAG2.pdf"; \
	OPTS="--tag $$TAG --name $$NAME"; \
	github-release release $$OPTS --pre-release || github-release edit $$OPTS --pre-release; \
	github-release upload $$OPTS --file ./$(OUTDIR)/diploma.pdf

.PHONY: clean force debug once all
