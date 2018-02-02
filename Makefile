md=$(shell find stata_markdown -name "*.md")
Stata_Rmd=$(md:.md=.Rmd)
md2=$(shell find stata_markdown -name "*.md" | sed 's.stata_markdown/..')
Stata_Ready=$(md2:.md=.Rmd)

stata_markdown/%.Rmd: stata_markdown/%.md
	@rm -f mycensus9.dta
	@echo "$< -> $@"
	@/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyndoc "$<", saving("$@") replace nostop'
# Convert ^#^ to #
	@sed -i '' 's.\^#\^.#.g' $@
# Convert ^$^ to $ and ^$$^ to $$
	@sed -i '' 's.\^$$^.$$.g' $@
	@sed -i '' 's.\^$$$$\^.$$$$.g' $@
# Remove <p>
	@sed -E -i '' 's.\<\/?p\>..g' $@
# This line makes all links open in new windows.
	@sed -i '' 's|href="|target="_blank" href="|g' $@

_book/index.html: index.Rmd $(Stata_Rmd)
	@echo "$< -> $@"
#	Get a list of Rmd files; we'll be temporarily copying them to the main directory
	@$(eval TMPPATH := $(shell find stata_markdown -name "*.Rmd"))
	@$(eval TMP := $(shell find stata_markdown -name "*.Rmd" | sed 's.stata_markdown/..'))
	@cp $(TMPPATH) .
# All images get copied too
	if [ $(shell find stata_markdown -name "*.svg" | wc -l) -gt 0 ]; then cp stata_markdown/*.svg .; fi
	@Rscript -e "bookdown::render_book('$<', 'bookdown::gitbook')"
#	Remove any files copies up
	@rm -rf $(TMP)
	@rm -rf *.svg

default: $(Stata_Rmd)  _book/index.html

clean:
	@git clean -xdf

open:
	@open _book/index.html
