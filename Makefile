# Directory and File Variables
TEX_DIR = tex
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OUTPUT_DIR = $(ROOT_DIR)/output
PDF_OUTPUT_DIR = $(OUTPUT_DIR)/pdf
SVG_OUTPUT_DIR = $(OUTPUT_DIR)/svg
BUILD_DIR = $(ROOT_DIR)/build

# List of .tex files in the TEX_DIR that do not start with an underscore
TEX_FILES := $(wildcard $(TEX_DIR)/*.tex)
TEX_FILES := $(filter-out $(TEX_DIR)/_%.tex, $(TEX_FILES))
PDF_FILES := $(patsubst $(TEX_DIR)/%.tex, $(PDF_OUTPUT_DIR)/%.pdf, $(TEX_FILES))
SVG_FILES := $(patsubst $(TEX_DIR)/%.tex, $(SVG_OUTPUT_DIR)/%.svg, $(TEX_FILES))

# Latex compilation command with BUILD_DIR for intermediate files
LATEXMK = latexmk -cd -pdf -shell-escape -outdir=$(BUILD_DIR) -auxdir=$(BUILD_DIR)

# Rule to compile all .tex files to .pdf and .svg
all: $(PDF_FILES) $(SVG_FILES)

# Individual PDF file compilation, moving final PDF to PDF_OUTPUT_DIR
$(PDF_OUTPUT_DIR)/%.pdf: $(TEX_DIR)/%.tex
	@mkdir -p $(PDF_OUTPUT_DIR) $(BUILD_DIR)
	$(LATEXMK) $<
	@mv $(BUILD_DIR)/$*.pdf $(PDF_OUTPUT_DIR)/

# Convert each PDF to SVG using pdf2svg, placing SVGs in SVG_OUTPUT_DIR
$(SVG_OUTPUT_DIR)/%.svg: $(PDF_OUTPUT_DIR)/%.pdf
	@mkdir -p $(SVG_OUTPUT_DIR)
	pdf2svg $< $@

# Clean command to remove generated files in OUTPUT_DIR and BUILD_DIR
clean:
	rm -rf $(OUTPUT_DIR)/* $(BUILD_DIR)/*

.PHONY: all clean
