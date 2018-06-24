
geotiff2df <- function(file, name="value", crop_extent=NA, valid_range=NA, scale_factor=NA) {
 rast <- raster(file)

 ## beschneide das GeoTiff mit crop (falls crop nicht NA ist)
 ## crop muss folgendes Format haben: c(xmin, xmax, ymin, xmax)
 if (!any(is.na(crop_extent)))
   rast = crop(rast, crop_extent)

 ## Setze valid range und scale factor (falls gegeben)
 if (!any(is.na(valid_range))) {
   rast[rast <= valid_range[1]] = NA
   rast[rast >= valid_range[2]] = NA
 }
 if (!is.na(scale_factor))
   rast = rast * scale_factor

 ## konvertiere in einen data.frame
 df <- as.data.frame(rasterToPoints(rast))
 colnames(df) <- c("x", "y", name)
 return(df)
}


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
