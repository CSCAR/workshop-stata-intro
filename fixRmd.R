library(stringr)
files <- dir(pattern = "^[0-9]")

regexp_to_replace <- "\\^#\\^"

for (f in files) {
  text <- readLines(f)
  sections <- str_detect(text, regexp_to_replace)
  text[sections] <- str_replace_all(text[sections], regexp_to_replace, "#")
  text[sections] <- str_replace_all(text[sections], "</?p>", "")
  write.table(text, f, row.names = FALSE, col.names = FALSE, quote = FALSE)
}
