local files : dir "stata_markdown" files "*.md"

foreach f in `files' {
  local f2 = substr("`f'", 1, strlen("`f'") - 3)
  dyndoc "stata_markdown/`f2'.md", saving("`f2'.Rmd") replace nostop
}
