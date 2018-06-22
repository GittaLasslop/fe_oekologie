library(raster)
library(ggplot2)
library(plyr)
library(reshape2)
library(FEglobaleOekologie)
fegloekOptions(baseDir = "/hier/muss/ihr/pfad/stehen")
fegloekOptions(region = "BORNEO")
fegloekInit()

# Erinnerung: die Daten liegen auf
# file='https://powerfolder.gwdg.de/filestable/MjRGYXU2YUViNThFdU5yMlFhZXV2'
# bitte herunterladen und in data Verzeichnis entzippen


# wie zuvor suchen Sie bitte dir richtigen Faktoren heraus

data.dir <- file.path(getOption("fegloekDataDir"), getOption("fegloekRegion"))
file <- file.path(data.dir, "MOD17A3_2010-01-01.Npp_1km.tif")
dfNPP <- geotiff2df(file, "NPP", valid_range = nppValidRange, 
                    scale_factor = nppScaleFactor)


# Die Variable LCT3lookuptable muss wieder eingelesen werden (externe txt Datei)

file <-file.path(data.dir, "MCD12Q1_2010-01-01.Land_Cover_Type_3.tif")
dfLCT <- geotiff2df(file, 'id', valid_range = c(0, 253))
dfLCT = merge(dfLCT, LCT3lookuptable, by="id", all.x=TRUE)


if (getOption("fegloekRegion") == "ALASKA" ||
    getOption("fegloekRegion") == "SAFRICA" ||
    getOption("fegloekRegion") == "SWAUSTRALIA" ||
    getOption("fegloekRegion") == "SEAUSTRALIA") {
    dfNPP$x = round(dfNPP$x, -3)
    dfNPP$y = round(dfNPP$y, -3)
    dfLCT$x = round(dfLCT$x, -3)
    dfLCT$y = round(dfLCT$y, -3)
}

dfData <- merge(dfNPP, dfLCT, by=c("x", "y"))

# Plotting

p <- ggplot(dfData, aes(x=name, y=NPP, fill=name))
p <- p + geom_boxplot()
p <- p + guides(fill=FALSE)
p <- p + xlab(NULL)
p <- p + ylab("NPP [kg(C)/m^2]")
p <- p + coord_flip()
```
```{r, eval=FALSE}
file <- paste0(getOption("fegloekRegion"), "_NPP.pdf")
pdf(file.path(getOption("fegloekFigDir"), file), paper="special", width=8, height=8)
print(p)
dev.off()

