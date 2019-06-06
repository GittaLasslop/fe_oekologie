install.packages("caret")
library(raster)
library(ggplot2)
library(reshape2)
library(caret)

setwd('S:/FGOE/')

geotiff2df <- function(file, name="value", valid_range=NA, scale_factor=NA, crop_extent=NA) {
  rast <- raster(file)
  
  ## beschneide das GeoTiff mit crop_extent (falls crop_extent nicht NA ist)
  ## crop muss folgendes Format haben: c(xmin, xmax, ymin, ymax)
  if(!is.na(crop_extent)){
    rast=crop(rast,extent(crop_extent))
  }
  ## Setze valid range und scale factor (falls gegeben)
  if (!is.na(valid_range)) {
    rast[rast < valid_range[1]] = NA
    rast[rast > valid_range[2]] = NA
  }
  if (!is.na(scale_factor)){
    rast = rast * scale_factor
  }
  ## konvertiere in einen data.frame
  df <- as.data.frame(rasterToPoints(rast))
  colnames(df) <- c("x", "y", name)
  return(df)
}

start_year <- 2001
end_year <- 2010

forestExtent = c(1000000, 1500000, 8500000, 9000000)
data.dir = 'Pfad zu ihrem Datenordner'
for (year in start_year:end_year) {
  file <- paste0("MCD12Q1_", year ,"-01-01.Land_Cover_Type_3.tif")
  dfLCT <- geotiff2df(file.path(data.dir, file), name="id", 
                      crop_extent =forestExtent, valid_range = c(0, 253))
  
  dfLCT$name = ""
  dfLCT$name[dfLCT$id < 5 | dfLCT$id > 8] = "unforested"
  dfLCT$name[dfLCT$id > 4 & dfLCT$id < 9] = "forested"
  dfLCT$name[dfLCT$id == 0] = "water"
  
  nFor = length(dfLCT$name[dfLCT$name == "forested"])
  nUnf = length(dfLCT$name[dfLCT$name == "unforested"])
  
  if (year == start_year) {
    tsForest = data.frame(Year=year, forested=nFor, unforested=nUnf)
  } else {
    tsForest = rbind(tsForest, data.frame(Year=year, forested=nFor, unforested=nUnf))
  }
  
  if (year == start_year || year == end_year) {
    p <- ggplot(dfLCT, aes(x=x, y=y))
    p <- p + geom_raster(aes(fill=name))
    p <- p + coord_fixed(xlim=c(min(dfLCT$x), max(dfLCT$x)),
                         ylim=c(min(dfLCT$y), max(dfLCT$y)))
    p <- p + theme(legend.position = "bottom")
    p <- p + scale_fill_manual(values=c("unforested"="brown", "forested"="darkgreen",
                                        "water"="lightblue"), drop=FALSE)
    p <- p + guides(fill = guide_legend(title=NULL, ncol = 4))
    p <- p + labs(title=year)
    p <- p + xlab("easting")
    p <- p + ylab("northing")
    file <- paste0("NWBRAZIL_LUC_", year, ".pdf")
#    pdf(file.path("Pfad zu ihrem Plot Ordner", file))
    print(p)
#    dev.off()
  }
}

tsForest = melt(tsForest, measure.vars=c("forested", "unforested"))
p <- ggplot(tsForest, aes(x=Year, y=value, fill=variable))
p <- p + geom_bar(stat="identity", position="dodge")
p <- p + scale_fill_manual(values=c("unforested"="brown", "forested"="darkgreen",
                                    "water"="lightblue"), drop=FALSE)

file <- paste0("BRAZIL_LUC_TS.pdf")
pdf(file.path('plots/LUC/', file), paper="special", width=10, height=6)
print(p)
dev.off()

forestExtent = c(1000000, 1500000, 8500000, 9000000)

year <- 2001
file <- paste0("MCD12Q1_", year ,"-01-01.Land_Cover_Type_3.tif")
dfLCT1 <- geotiff2df(file.path(data.dir, file), name="id", 
                     crop_extent =forestExtent, valid_range = c(0, 253))

idx.forest.2001 <- which(dfLCT1$id > 4 & dfLCT1$id < 9)

year <- 2010
file <- paste0("MCD12Q1_", year ,"-01-01.Land_Cover_Type_3.tif")
dfLCT2 <- geotiff2df(file.path(data.dir, file), name="id", 
                     crop_extent =forestExtent, valid_range = c(0, 253))
idx.noforest.2010 <- which(dfLCT2$id < 5 | dfLCT2$id > 8)

idx.change <- intersect(idx.forest.2001, idx.noforest.2010)

dfLCT.change <- dfLCT2[idx.change, ]

file <- 'LCT3Lookuptable.txt'
LCT3lookuptable=read.table(file.path(data.dir, file),header=T)
dfLCT.change = merge(dfLCT.change, LCT3lookuptable, by="id", all.x=TRUE)

table(dfLCT.change$name)

df.change <- as.data.frame(table(dfLCT.change$name))
colnames(df.change) <- c("Class","Freq")
df.change <- df.change[which(df.change$Freq!=0),]
df.change

p <- ggplot(df.change, aes(x=Class, y = Freq, fill=Class))
p <- p + geom_bar(width = 1, stat = "identity", color = "black")
p <- p + coord_flip()
print(p)

forestExtent = c(1000000, 1500000, 8500000, 9000000)
year <- 2010
file <- paste0("MCD12Q1_", year ,"-01-01.Land_Cover_Type_3.tif")
modis <- raster(file.path(data.dir, file))
modis <- crop(modis, forestExtent)

valid_range <- c(0, 253)
if (!any(is.na(valid_range))) {
  modis[modis <= valid_range[1]] = NA
  modis[modis >= valid_range[2]] = NA
}

projection(modis)
#[1] "+proj=utm +zone=20 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"

file <- "ESACCI-LC-L4-LCCS-Map-300m-2010-Subset.tif"
esa <- raster(file.path(data.dir, file))
projection(esa)

Mode <- function(x, ...) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
esa.agg <- aggregate(esa, fact=4, fun=Mode, expand=TRUE, na.rm=TRUE)

modis.longlat <- projectRaster(from=modis, to=esa.agg, method="ngb") #nearest neighbor

esa.agg.reclass <- esa.agg
esa.agg.reclass[esa.agg.reclass == 0] <- 255
esa.agg.reclass[esa.agg.reclass == 10] <- 1
esa.agg.reclass[esa.agg.reclass == 11] <- 1
esa.agg.reclass[esa.agg.reclass == 12] <- 3
esa.agg.reclass[esa.agg.reclass == 20] <- 1
esa.agg.reclass[esa.agg.reclass == 30] <- 4
esa.agg.reclass[esa.agg.reclass == 40] <- 4
esa.agg.reclass[esa.agg.reclass == 50] <- 5
esa.agg.reclass[esa.agg.reclass == 60] <- 6
esa.agg.reclass[esa.agg.reclass == 61] <- 6
esa.agg.reclass[esa.agg.reclass == 62] <- 6
esa.agg.reclass[esa.agg.reclass == 70] <- 7
esa.agg.reclass[esa.agg.reclass == 71] <- 7
esa.agg.reclass[esa.agg.reclass == 72] <- 7
esa.agg.reclass[esa.agg.reclass == 80] <- 8
esa.agg.reclass[esa.agg.reclass == 81] <- 8
esa.agg.reclass[esa.agg.reclass == 82] <- 8
esa.agg.reclass[esa.agg.reclass == 90] <- 5
esa.agg.reclass[esa.agg.reclass == 100] <- 4
esa.agg.reclass[esa.agg.reclass == 110] <- 4
esa.agg.reclass[esa.agg.reclass == 120] <- 2
esa.agg.reclass[esa.agg.reclass == 121] <- 2
esa.agg.reclass[esa.agg.reclass == 122] <- 2
esa.agg.reclass[esa.agg.reclass == 130] <- 1
esa.agg.reclass[esa.agg.reclass == 140] <- 1
esa.agg.reclass[esa.agg.reclass == 150] <- 9
esa.agg.reclass[esa.agg.reclass == 152] <- 9
esa.agg.reclass[esa.agg.reclass == 153] <- 9
esa.agg.reclass[esa.agg.reclass == 160] <- 5
esa.agg.reclass[esa.agg.reclass == 170] <- 5
esa.agg.reclass[esa.agg.reclass == 180] <- 2
esa.agg.reclass[esa.agg.reclass == 190] <- 10
esa.agg.reclass[esa.agg.reclass == 200] <- 9
esa.agg.reclass[esa.agg.reclass == 201] <- 9
esa.agg.reclass[esa.agg.reclass == 202] <- 9
esa.agg.reclass[esa.agg.reclass == 210] <- 0
esa.agg.reclass[esa.agg.reclass == 220] <- 255

library(caret)

modis.factor <- factor(values(modis.longlat), levels = c(0,1,2,3,4,5,6,7,8,9,10))
esa.factor <- factor(values(esa.agg.reclass), levels = c(0,1,2,3,4,5,6,7,8,9,10))
confusionMatrix(data=modis.factor, reference=esa.factor, dnn = c("MODIS", "ESA"))
