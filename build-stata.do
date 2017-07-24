local files 02-basics 03-working-with-data-sets 04-data-management ///
			05-data-manipulation 06-programming

foreach f in `files' {
	dyndoc stata_markdown/`f'.md, saving("`f'.Rmd") replace nostop
}
