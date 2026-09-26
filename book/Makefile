# Makefile for AE 2440 — Introduction to Scientific Programming
#
# Builds standalone chapters, assignments, and the master book PDF.
# All PDFs are written alongside their .tex source.

LATEXMK := latexmk -pdf -interaction=nonstopmode -f

CHAPTERS_TEX    := $(wildcard w*/chapter/*.tex)
CHAPTERS_PDF    := $(CHAPTERS_TEX:.tex=.pdf)
ASSIGNMENTS_TEX := $(wildcard w*/assign/*.tex)
ASSIGNMENTS_PDF := $(ASSIGNMENTS_TEX:.tex=.pdf)

WEEK_NUMS    := 01 02 03 04 05 06 07 08 09 10
WEEK_TARGETS := $(addprefix w,$(WEEK_NUMS))

.PHONY: all chapters assignments book images-png clean distclean help $(WEEK_TARGETS)

all: chapters assignments book

help:
	@echo "Targets:"
	@echo "  all          Build every chapter standalone, every assignment, and the book"
	@echo "  book         Build book.pdf"
	@echo "  chapters     Build all standalone chapter PDFs"
	@echo "  assignments  Build all assignment PDFs"
	@echo "  wNN          Build chapter + assignment for week NN (e.g. make w03)"
	@echo "  images-png   Rasterize PDF/EPS figures in images/ to PNG for the live-script chapters"
	@echo "  clean        Remove latexmk aux files (keep PDFs)"
	@echo "  distclean    Remove all generated files including PDFs"

chapters: $(CHAPTERS_PDF)
assignments: $(ASSIGNMENTS_PDF)
book: book.pdf

book.pdf book.aux &: book.tex $(CHAPTERS_TEX)
	$(LATEXMK) -cd $< || test -f $@

# Standalone chapter / assignment PDFs depend on book.aux so that
# cross-chapter references (e.g. \ref{fzero} from the optimization
# chapter) resolve via xr-hyper. book.aux is produced as a side-effect
# of building book.pdf.
$(CHAPTERS_PDF) $(ASSIGNMENTS_PDF): %.pdf: %.tex book.aux
	$(LATEXMK) -cd $< || test -f $@

# Per-week shortcut: make w03, make w04, ...
define week_rule
w$(1): $(patsubst %.tex,%.pdf,$(wildcard w$(1)_*/chapter/*.tex)) \
       $(patsubst %.tex,%.pdf,$(wildcard w$(1)_*/assign/*.tex))
endef
$(foreach n,$(WEEK_NUMS),$(eval $(call week_rule,$(n))))

# PNG twins of the vector figures, for the live-script chapters (the Live
# Editor cannot show PDF or EPS). EPS is preferred as the source: the EPS files
# carry a tight bounding box, while several of the PDF twins are full letter
# pages with the drawing rotated. PDF-only figures are trimmed after rendering.
# Rebuilt only when the source is newer.
IMAGES_EPS      := $(wildcard images/*.eps)
IMAGES_PDF_ONLY := $(filter-out $(IMAGES_EPS:.eps=.pdf),$(wildcard images/*.pdf))
IMAGES_SKIP     := images/figure04_01_new_v1.png images/matlab_circleart.png
IMAGES_PNG      := $(filter-out $(IMAGES_SKIP),$(IMAGES_EPS:.eps=.png) $(IMAGES_PDF_ONLY:.pdf=.png))

images-png: $(IMAGES_PNG)

images/%.png: images/%.eps
	gs -q -dSAFER -dBATCH -dNOPAUSE -dEPSCrop -sDEVICE=png16m -r150 -sOutputFile=$@ $<

images/%.png: images/%.pdf
	pdftoppm -png -r 150 -singlefile $< images/$*
	convert $@ -trim +repage -bordercolor white -border 12 $@

clean:
	@for f in $(CHAPTERS_TEX) $(ASSIGNMENTS_TEX) book.tex; do \
		latexmk -c -cd $$f >/dev/null 2>&1 || true; \
	done

distclean:
	@for f in $(CHAPTERS_TEX) $(ASSIGNMENTS_TEX) book.tex; do \
		latexmk -C -cd $$f >/dev/null 2>&1 || true; \
	done
