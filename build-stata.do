local files 01-basics 02-working-with-data-sets 03-data-management ///
			04-data-manipulation 05-programming

foreach f in `files' {
	dyndoc stata_markdown/`f'.md, saving("`f'.Rmd") replace nostop
}
