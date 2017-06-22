# Intro to Stata Notes (Bookdown)

Create Stata [dyndoc](http://www.stata.com/manuals/pdyndoc.pdf) files inside the stata-do folder, named `##-name.do`. Then use the Makefile to process them:

- `make stata`: Converts the Stata .do files into Rmarkdown files (really just HTML renamed to .Rmd) in the main directory.
- `make fixRmd`: The first line of each .Rmd file needs to be a section header (e.g. `# Introduction`) instead of HTML as they are produced by Stata's `dyndoc`. This fixes all .Rmd files.
- `make book`: Compiles the book.
- `make`: Performs the above three actions.
