library(stringr)
files <- dir(pattern = "^[0-9]")


for (f in files) {
  text <- readLines(f)

  # Fix section headers
  section_regexp <- "\\^#\\^"
  sections <- str_detect(text, section_regexp)
  text[sections] <- str_replace_all(text[sections], section_regexp, "#")
  text[sections] <- str_replace_all(text[sections], "</?p>", "")

  # Fix equations
  display_eq_regexp <- "^$$^"
  sections <- str_detect(text, fixed(display_eq_regexp))
  text[sections] <- str_replace_all(text[sections], fixed(display_eq_regexp), "$$")
  text[sections] <- str_replace_all(text[sections], "</?p>", "")

  inline_regexp <- "^$^"
  sections <- str_detect(text, fixed(inline_regexp))
  text[sections] <- str_replace_all(text[sections], fixed(inline_regexp), "$")

  # Fix > and <
  #text <- str_replace_all(text, fixed("&gt;"), ">")
  #text <- str_replace_all(text, fixed("&lt;"), "<")


  write.table(text, f, row.names = FALSE, col.names = FALSE, quote = FALSE)
}
