BUILD = build
BOOKNAME = my-book
TITLE = title.txt
METADATA = metadata.xml
CHAPTERS = ch01.md ch02.md
TOC = --toc --toc-depth=2
COVER_IMAGE = images/cover.jpg
LATEX_CLASS = report

all: book

book: epub mobi html pdf markdown

clean:
	rm -r $(BUILD)

epub: $(BUILD)/epub/$(BOOKNAME).epub
	
mobi: $(BUILD)/mobi/$(BOOKNAME).epub

html: $(BUILD)/html/$(BOOKNAME).html

pdf: $(BUILD)/pdf/$(BOOKNAME).pdf

markdown: $(BUILD)/markdown/$(BOOKNAME).markdown

$(BUILD)/epub/$(BOOKNAME).epub: $(TITLE) $(CHAPTERS)
	mkdir -p $(BUILD)/epub
	pandoc $(TOC) -S --template templates/custom.epub --epub-stylesheet=css/epub.css --epub-metadata=$(METADATA) --epub-cover-image=$(COVER_IMAGE) -o $@ $^
	
$(BUILD)/mobi/$(BOOKNAME).epub: $(TITLE) $(CHAPTERS)
	mkdir -p $(BUILD)/mobi
	pandoc $(TOC) -S --template templates/custom.epub --epub-stylesheet=css/epub.css --epub-metadata=$(METADATA) --epub-cover-image=$(COVER_IMAGE) -o $@ $<
	$(KINDLEGEN) $(KINDLEGEN_OPTS) $@ > /dev/null
	rm $(BUILD)/mobi/$(BOOKNAME).epub

$(BUILD)/html/$(BOOKNAME).html: $(CHAPTERS)
	mkdir -p $(BUILD)/html
	pandoc $(TOC) --standalone --template templates/custom.html5 --to=html5 -o $@ $^

$(BUILD)/pdf/$(BOOKNAME).pdf: $(TITLE) $(CHAPTERS)
	mkdir -p $(BUILD)/pdf
	pandoc $(TOC) --template templates/custom.latex --latex-engine=xelatex -V documentclass=$(LATEX_CLASS) -o $@ $^

$(BUILD)/markdown/$(BOOKNAME).markdown: $(CHAPTERS)
	mkdir -p $(BUILD)/markdown
	pandoc -S $(METADATA) -o $@ $^

.PHONY: all book clean epub mobi html pdf markdown
