# Directory and File Variables
TEX_DIR = tex
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OUTPUT_DIR = $(ROOT_DIR)/output
PDF_OUTPUT_DIR = $(OUTPUT_DIR)/pdf
SVG_OUTPUT_DIR = $(OUTPUT_DIR)/svg
BUILD_DIR = $(ROOT_DIR)/build

# Find all .tex files in TEX_DIR and its subdirectories, excluding those starting with an underscore
TEX_FILES := $(shell find $(TEX_DIR) -type f -name '*.tex' ! -name '_*.tex')
PDF_FILES := $(patsubst $(TEX_DIR)/%.tex, $(PDF_OUTPUT_DIR)/%.pdf, $(TEX_FILES))
SVG_FILES := $(patsubst $(TEX_DIR)/%.tex, $(SVG_OUTPUT_DIR)/%.svg, $(TEX_FILES))
BUILD_FILES := $(patsubst $(TEX_DIR)/%.tex, $(BUILD_DIR)/%.aux, $(TEX_FILES)) # Example of intermediate files

# Latex compilation command
LATEXMK = latexmk -cd -pdf -shell-escape

# Rule to compile all .tex files to .pdf and .svg
all: $(PDF_FILES) $(SVG_FILES)

# Rule for compiling PDFs, preserving subdirectory structure
$(PDF_OUTPUT_DIR)/%.pdf: $(TEX_DIR)/%.tex
	@mkdir -p $(dir $@) $(BUILD_DIR)/$(dir $*)
	$(LATEXMK) -outdir=$(BUILD_DIR)/$(dir $*) $<
	@mv $(BUILD_DIR)/$*.pdf $@

# Rule for converting PDFs to SVGs, preserving subdirectory structure
$(SVG_OUTPUT_DIR)/%.svg: $(PDF_OUTPUT_DIR)/%.pdf
	@mkdir -p $(dir $@)
	pdf2svg $< $@

# Clean command to remove generated files in OUTPUT_DIR and BUILD_DIR
clean:
	rm -rf $(OUTPUT_DIR) $(BUILD_DIR)

.PHONY: all clean
