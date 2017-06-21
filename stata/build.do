local files 01-basics 02-working-with-data-sets 03-data-management ///
			04-data-manipulation 05-programming

foreach f in `files' {
	dyndoc `f'.do, saving("../`f'.Rmd") replace
}
