library(raster)
library(ggplot2)
library(reshape2)
library(FEglobaleOekologie)
fegloekOptions(baseDir = "/hier/muss/ihr/pfad/stehen")
fegloekOptions(region = "NEUROPE")
fegloekInit()

# Erinnerung: die Daten liegen auf
# file='https://powerfolder.gwdg.de/filestable/MjRGYXU2YUViNThFdU5yMlFhZXV2'
# bitte herunterladen und in data Verzeichnis entzippen

file.path(getOption("fegloekDataDir"),getOption("fegloekRegion"))

data.dir <- file.path(getOption("fegloekDataDir"), getOption("fegloekRegion"))
files <- list.files(data.dir, pattern = "NDVI.tif$",full.names = TRUE)
stackNDVI <-stack(files)

sPoints <- SpatialPoints(getOption("fegloekPoints"), proj4string =CRS("+proj=longlat +ellps=WGS84"))
sPointsUTM <-spTransform(sPoints, CRS(projection(stackNDVI)))

dfNDVI <-extract(stackNDVI, sPointsUTM, df = TRUE)
dfNDVI$ID = NULL

filenames <- colnames(dfNDVI)
ndviDate <- extractDate(filenames)

# suchen sie die passenden Werte fuer ndviScaleFactor und ndviLowerLimit

dfNDVI[dfNDVI <= ndviLowerLimit] = NA
dfNDVI = dfNDVI*ndviScaleFactor

ndviMin <- apply(dfNDVI, 1, "min", na.rm = TRUE)
ndviMax <-apply(dfNDVI, 1, "max", na.rm = TRUE)
ndviMid <- (ndviMax + ndviMin)/2

dfNDVI = data.frame(date = ndviDate, t(dfNDVI))

# plotting

file <- paste0(getOption("fegloekRegion"), "_NDVI.pdf")

pdf(file.path(getOption("fegloekFigDir"), file), paper = "special", width = 8, height = 8)
p <- ggplot(melted.dfNDVI, aes(x = date, y = value))
p <- p + geom_line()
p <- p + geom_hline(data = ndviMid, aes(yintercept = value), colour = "blue", linetype = "dashed")
p <- p + scale_x_date()
p <- p + xlab("Datum")
p <- p + facet_wrap(~variable, ncol = 1)
p <- p + ylab("NDVI")

print(p)

# nicht vergessen !!! notwendig um den it pdf() geoeffneten Ausgabekanal wieder zu schliessen und
# die PDF-Datei sauber zu schliessen...
dev.off()


melted.dfNDVI <- melt(dfNDVI, id.vars="date")
ndviMid <- data.frame(variable=paste0("X", 1:4), value=ndviMid)

file <- paste0(getOption("fegloekRegion"), "_NDVI.pdf")
pdf(file.path(getOption("fegloekFigDir"), file), paper="special", width=8, height=8)

p <- ggplot(melted.dfNDVI, aes(x=date, y=value))
p <- p + geom_line()
p <- p + geom_hline(data=ndviMid, aes(yintercept=value),
                    colour="blue", linetype="dashed")
p <- p + scale_x_date()
p <- p + xlab("Datum")
p <- p + facet_wrap(~variable, ncol=1)
p <- p + ylab("NDVI")
print(p)

dev.off()


