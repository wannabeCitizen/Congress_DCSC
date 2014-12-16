TITLE	:= Skirpan+Coughlin_Final_Paper
PANDOC	:= pandoc -V geometry:paperheight=9.5in -V geometry:paperwidth=7in -o

pdf: $(TITLE).pdf

$(TITLE).pdf: $(TITLE).md
	$(PANDOC) $(TITLE).pdf $(TITLE).md

clean:
	$(RM) $(TITLE).pdf
