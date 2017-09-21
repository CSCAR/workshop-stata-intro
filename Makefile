default: stata fixRmd book

stata:
	@rm -f mycensus9.dta
	/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b do build-stata.do

fixRmd:
	R -q -f fixRmd.R

book:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

clean:
	@rm -rf 0*.Rmd _book build-stata.log

fresh: clean default

open:
	@open _book/index.html
