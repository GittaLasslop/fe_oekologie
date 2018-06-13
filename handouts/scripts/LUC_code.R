library(raster)
library(ggplot2)
library(reshape2)
library(FEglobaleOekologie)

fegloekOptions(baseDir = "/Users/cwerner/Dropbox/Documents/2018/teaching/fe_oekologie_2018/handouts")
fegloekOptions(region="NWBRAZIL")
fegloekInit()

# Lesefunktion aus den letzten Sitzungen
#

geotiff2df <- function(file, name="value", valid_range=NA, crop_extent=NA, scale_factor=NA) {
 rast <- raster(file)

 ## AUFGABE:
 ## > Beschneide das GeoTiff mit crop (falls crop nicht NA ist)

 ## HINWEIS:
 ## Wir benoetigen (1) ein zusaetzliches Funktionsargument 'crop_extent' mit dem Standardwert
 ## NA (nicht definiert) 
 ## Weiterhin benoetigen wir (2) den Befehl crop (?crop) um die Ausdehnung unserer Karte
 ## auf die Grenzen 'crop_extent' zu beschneiden.

 ## Fuer den Aufbau der if-Bedingung koennen Sie sich bei der folgenden Abfrage von
 ## 'valid_range' inspirieren lassen


 ## NEUEN CODE HIER EINSETZEN
 if (!any(is.na(crop_extent))) {
  rast <- crop(rast, crop_extent)
 }
 ## ENDE FUER NEUEN CODE


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




# Erinnerung: die Daten liegen auf
# file='https://powerfolder.gwdg.de/filestable/MjRGYXU2YUViNThFdU5yMlFhZXV2'
# bitte herunterladen und in data Verzeichnis entzippen


## (1) Karten

fpath <- file.path(getOption("fegloekDataDir"),getOption("fegloekRegion"))
message(fpath)


start_year <- 2001
end_year <- 2010

forestExtent <- getOption("fegloekLUCExtent")
data.dir <- file.path(getOption("fegloekDataDir"), getOption("fegloekRegion"))
for (year in start_year:end_year) {
  file <- paste0("MCD12Q1_", year ,"-01-01.Land_Cover_Type_3.tif")
  dfLCT <- geotiff2df(file.path(data.dir, file), name="id", crop_extent=forestExtent, valid_range = c(0, 253))

  # reproject border lines, if not yet done
  if (!exists("regionmap")) {
    rLCT <- raster(file.path(data.dir, file))
    rLCT = crop(rLCT, forestExtent)
    regionmap = borderSubset(rLCT)
  }

  dfLCT$name=""
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
    p <- p + geom_path(data=regionmap, size=0.1, colour="black", aes(x=long, y=lat, group=group))
    p <- p + coord_fixed(xlim=c(min(dfLCT$x), max(dfLCT$x)),
                         ylim=c(min(dfLCT$y), max(dfLCT$y)))
    p <- p + theme(legend.position = "bottom")
    p <- p + scale_fill_manual(values=c("unforested"="brown", "forested"="darkgreen",
                                        "water"="lightblue"), drop=FALSE)
    p <- p + guides(fill = guide_legend(title=NULL, ncol = 4))
    ##label = paste0(nFor, " * km^2")
    ##p <- p + annotate("text", label=label, x=3e5, y=9.05e6,
    ##                  color="white", parse=TRUE, size=6)
    ##label = paste0(nUnf, " * km^2")
    ##p <- p + annotate("text", label=label, x=3e5, y=8.95e6,
    ##                  color="white", parse=TRUE, size=6)
    p <- p + labs(title=year)
    p <- p + xlab("easting")
    p <- p + ylab("northing")
    file <- paste0(getOption("fegloekRegion"), "_LUC_", year, ".pdf")
    pdf(file.path(getOption("fegloekFigDir"), file), paper="special", width=10, height=6)
    print(p)
    dev.off()
  }
}



## (2) Zeitreihe
tsForest = melt(tsForest, measure.vars=c("forested", "unforested"))
p <- ggplot(tsForest, aes(x=Year, y=value, fill=variable))
p <- p + geom_bar(stat="identity", position="dodge")
p <- p + scale_fill_manual(values=c("unforested"="brown", "forested"="darkgreen",
                                        "water"="lightblue"), drop=FALSE)

## p <- p + facet_wrap(~variable, ncol=1, scales="free_y")

file <- paste0(getOption("fegloekRegion"), "_LUC_TS.pdf")
pdf(file.path(getOption("fegloekFigDir"), file), paper="special", width=10, height=6)
print(p)
dev.off()


## (3) Animation

## Installation des Zusatzpakets
library(devtools)
devtools::install_github("dgrtwo/gganimate")
## laden des neuen Pakets
library(gganimate)


forestExtent <- getOption("fegloekLUCExtent")
data.dir <- file.path(getOption("fegloekDataDir"), getOption("fegloekRegion"))

list_of_dfLCTs = list()
cnt = 1

for (year in start_year:end_year) {
  print(year)

  file <- paste0("MCD12Q1_", year ,"-01-01.Land_Cover_Type_3.tif")
  dfLCT <- geotiff2df(file.path(data.dir, file), name="id", crop=forestExtent, valid_range = c(0, 253))

  # reproject border lines, if not yet done
  if (!exists("regionmap")) {
    rLCT <- raster(file.path(data.dir, file))
    rLCT = crop(rLCT, forestExtent)
    regionmap = borderSubset(rLCT)
  }

  dfLCT$name=""
  dfLCT$name[dfLCT$id < 5 | dfLCT$id > 8] = "unforested"
  dfLCT$name[dfLCT$id > 4 & dfLCT$id < 9] = "forested"
  dfLCT$name[dfLCT$id == 0] = "water"

  dfLCT$year=year
  
  list_of_dfLCTs[[cnt]] = dfLCT
  cnt = cnt + 1
}

## Verknuepfung der einzelnen dfLCT data.frames zu einem grossen data.frame
dfLCT_total <- do.call("rbind", list_of_dfLCTs)

## Transformation mit melt
#print(head(dfLCT_total))
#dfLCT_total_melted <- melt(dfLCT_total, measure.vars=c("name"))

#print(head(dfLCT_total_melted))

p <- ggplot(dfLCT_total, aes(x=x, y=y, frame=year))
p <- p + geom_raster(aes(fill=name))
p <- p + geom_path(data=regionmap, size=0.1, colour="black", aes(x=long, y=lat, group=group))
p <- p + coord_fixed(xlim=c(min(dfLCT$x), max(dfLCT$x)),
                         ylim=c(min(dfLCT$y), max(dfLCT$y)))
p <- p + theme(legend.position = "bottom")
p <- p + scale_fill_manual(values=c("unforested"="brown", "forested"="darkgreen",
                                        "water"="lightblue"), drop=FALSE)
p <- p + guides(fill = guide_legend(title=NULL, ncol = 4))


## label = paste0(nFor, " * km^2")
## p <- p + annotate("text", label=label, x=3e5, y=9.05e6,
##                  color="white", parse=TRUE, size=12)
## label = paste0(nUnf, " * km^2")
## p <- p + annotate("text", label=label, x=3e5, y=8.95e6,
##                  color="white", parse=TRUE, size=12)
    
#p <- p + labs(title=year)
p <- p + xlab("easting")
p <- p + ylab("northing")

gganimate(p, filename="meine_animation.html")

## falls sie die animation in ein GIF speicher wollen (sie benötigen ImageMagick dafuer)
## gganimate(p, "animation.gif")


