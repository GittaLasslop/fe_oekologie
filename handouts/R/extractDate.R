extractDate <- function(fnames) {
  date.str.pos <- regexpr("[0-9]{4}[.-][0-9]{2}[.-][0-9]{2}", fnames)
  date.str <- substr(fnames, as.numeric(date.str.pos),
                     as.numeric(date.str.pos) + attr(date.str.pos, "match.length") -1)
  if (all(grepl("-", date.str))) {
    dates <- as.Date(date.str, format="%Y-%m-%d")
  } else if (all(grepl(".", date.str))) {
    dates <- as.Date(date.str, format="%Y.%m.%d")
  } else {
    warning("Problem extracting dates from given filenames (fnames). Tried my best, but don't trust the results!")
    dates <- as.Date(date.str)
  }
  return(dates)
}
