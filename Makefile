RMD_FILE = README.Rmd
PDF_FILE = ${RMD_FILE:%.Rmd=%.pdf}
HTML_FILE = ${RMD_FILE:%.Rmd=%.html}
MD_FILE = ${RMD_FILE:%.Rmd=%.md}

BIBFILE = assignment2.bib

all: $(PDF_FILE) $(HTML_FILE) $(MD_FILE)

$(PDF_FILE): $(RMD_FILE) $(wildcard includes/*.tex) $(BIBFILE)
	Rscript -e 'rmarkdown::render("$<",output_format="pdf_document")'


$(HTML_FILE): $(RMD_FILE) $(wildcard includes/*.html) $(BIBFILE)
	Rscript -e 'rmarkdown::render("$<",output_format="html_document")'


$(MD_FILE): $(RMD_FILE) $(BIBFILE)
	Rscript -e 'rmarkdown::render("$<",output_format="md_document")'
