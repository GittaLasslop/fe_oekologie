#' @importFrom raster raster crop rasterToPoints
## erweitern mit scale_factor und valid_range für PHEN und folgende
## erweitern mit crop für VegDyn und LUC

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
