library(stringr)
files <- dir(pattern = "^[0-9]")

for (f in files) {
  text <- read.table(f, sep = "\n", stringsAsFactors = FALSE)[,, drop = TRUE]
  text[1] <- str_c("# ", str_replace_all(text[1], "<[^>]*>", ""))
  write.table(text, f, row.names = FALSE, col.names = FALSE, quote = FALSE)
}
