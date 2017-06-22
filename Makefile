default: stata fixRmd book

stata:
	/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b do stata-build.do

fixRmd:
	R -q -f fixRmd.R

book:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

clean:
	@rm -rf 0*.Rmd _book stata-build.log

fresh: clean default
