TITLE	:= Skirpan+Coughlin_Final_Paper
PANDOC	:= pandoc -V geometry:paperheight=9in -V geometry:paperwidth=6.5in -o

pdf: $(TITLE).pdf

$(TITLE).pdf: $(TITLE).md
	$(PANDOC) $(TITLE).pdf $(TITLE).md

clean:
	$(RM) $(TITLE).pdf
