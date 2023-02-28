md = $(shell find stata_markdown -name "*.md")
Stata_Rmd = $(md:.md=.Rmd)

stata_markdown/%.Rmd: stata_markdown/%.md
	@rm -f mycensus9.dta
	@echo "$< -> $@"
	@/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyntext "$<", saving("$@") replace nostop'
#	Using <<dd_do: quiet>> produces empty codeblocks in output, remove them
	@perl -0777 -i -pe 's/~~~~\n~~~~//g' $@

docs/index.html: index.Rmd $(Stata_Rmd)
	@echo "$< -> $@"
#	Bring images temporarily up to main directory
	@cp $(stata_file_path)/*.svg . 2>/dev/null || :
	@Rscript -e "bookdown::render_book('$<', 'bookdown::gitbook')"
#	Remove any images copied up
	@rm -rf *.svg

default: $(Stata_Rmd)  docs/index.html

.PHONY:clean
clean:
	@git clean -xdf

open:
	@open docs/index.html
