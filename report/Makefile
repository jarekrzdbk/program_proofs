# --------------- 100 % bullet‑proof Makefile -----------------
MAKEFLAGS += -rR        # drop every built‑in rule/variable
.SUFFIXES:              # clear suffix list

export TEXINPUTS := .:texinputs:text-parts::
export BIBINPUTS := .:bibliography:

# absolute names, no concatenation → no risk of stray blanks
PDF      = manuscript.pdf
TEX      = manuscript.tex
BIBFILE  = bibliography/citations.bib
PARTS    = $(wildcard texinputs/*.tex text-parts/*.tex)

.PHONY: all clean view
all: $(PDF)

$(PDF): $(TEX) $(PARTS) $(BIBFILE)
	latexmk -pdf -synctex=1 -interaction=nonstopmode -f $(TEX)

view: $(PDF)
	xdg-open $(PDF) &

clean:
	latexmk -C
# -------------------------------------------------------------

