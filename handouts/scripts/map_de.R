## ---- Pakete installieren------------------------------------------

for (p in c("raster", "rgeos", "ggplot2", "rworldmap", "maps", "mapproj", "rgdal", "devtools")) {
  if (!require(p, character.only=TRUE)) {
    install.packages(p)
    library(p, character.only=TRUE)
  }
}
if (!require(FEglobaleOekologie)) {
  library("devtools")
  install_github("joergsteinkamp/FEglobaleOekologie")
}


## ---- Pakete laden-----------------------
library(raster)
library(ggplot2)
library(FEglobaleOekologie)

# FE Oekologie Skript initialisieren
fegloekOptions(baseDir = "/home/gitta/R/Lehre")
fegloekOptions(region = "ALASKA")
fegloekInit()
fegloekOptions()

# Variablen und Funktionen laden
source(file.path(getOption("fegloekBaseDir"), "R", "variables.R"), encoding=getOption("encoding"))
source(file.path(getOption("fegloekBaseDir"), "R", "functions.R"), encoding=getOption("encoding"))

# Ein plot (ggplot2)
worldmap <- map_data("world")
p <- ggplot(worldmap, aes(y=lat, x=long, group=group))
p = p + geom_path()
p = p + coord_fixed()
p = p + labs(title="Laendergrenzen")
p = p + xlab("Laenge")
p = p + ylab("Breite")
print(p)

## ------------------------------------------------------------------------
fileName <- paste0("LUC_", getOption("fegloekRegion"), 
                   ".zip")
file='https://powerfolder.gwdg.de/dl/fiXNVFhCv7bwzo33Hj8Rys5L/LUC_ALASKA.zip'
download.file(file,file.path(getOption("fegloekDataDir"),fileName))
unzip(file.path(getOption("fegloekDataDir"), fileName), 
            exdir = getOption("fegloekDataDir"))

## ------------------------------------------------------------------------
year <- 2001
lct <- 3
data.dir <- file.path(getOption("fegloekDataDir"), getOption("fegloekRegion"))
file <- file.path(data.dir, paste0("MCD12Q1_GEO_lres_", year, "-01-01.Land_Cover_Type_", lct, ".tif"))

## ------------------------------------------------------------------------
rLCT  <- raster(file)
dfLCT <- as.data.frame(rasterToPoints(rLCT))
colnames(dfLCT) <- c("x", "y", "id")

dfLCT = subset(dfLCT, id < 254)
dfLCT = merge(dfLCT, LCT3lookuptable, by="id", all.x=TRUE)


points <- getOption("fegloekPoints")
p <- ggplot(dfLCT, aes(x = x, y = y))
p = p + geom_raster(aes(fill = name))
p = p + geom_path(data = worldmap, size = 0.1, colour = "black",
                  aes(x = long, y = lat, group = group))
p = p + geom_point(data = points, aes(x = long, y = lat),
                   color = "black", shape = 10, size = 2.5)
p = p + geom_text(data = points, aes(x = long, y = lat, label =
                  paste0("V", rownames(points))),
                  hjust = c(-0.1, -0.1, 1.1, 1.1))
p = p + coord_fixed(xlim = c(min(dfLCT$x), max(dfLCT$x)),
                    ylim = c(min(dfLCT$y), max(dfLCT$y)), expand = FALSE)
p = p + theme(legend.position = "bottom")
p = p + guides(fill = guide_legend(title = NULL, ncol = 3))
p = p + labs(title = "MODIS MCD12Q1 Landcover")
p = p + xlab("Longitude")
p = p + ylab("Latitude")

print(p)

# output in eine datei
file <- paste0(getOption("fegloekRegion"), "_LCT", lct, "_", year, ".pdf")
pdf(file.path(getOption("fegloekFigDir"), file), paper="special", width=10, height=10)
print(p)
dev.off()


