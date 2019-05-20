# Skript zum handout mapPhen: Phänologie
# installieren und laden von paketen
for (p in c("raster", "rgeos", "ggplot2", "rworldmap", 
            "maps", "mapproj", "rgdal", "reshape2")) {
  if (!require(p, character.only=TRUE)) {
    install.packages(p)
  }
  library(p, character.only=TRUE)
}
setwd('S:/FGOE/')
data.dir='data/PHEN/NEUROPE/'
plot.dir='plots/PHEN/'
dir.create(plot.dir)
dir.create(data.dir)
# Weltkarte mit ggplot
library(ggplot2)
worldmap <- map_data("world")
p <- ggplot(worldmap, aes(y=lat, x=long, group=group))
p = p + geom_path()
p = p + coord_fixed()
p = p + labs(title="Laendergrenzen")
p = p + xlab("Laenge")
p = p + ylab("Breite")
print(p)

# projizieren in andere Koordinatensysteme
PointsDF = data.frame(long=c(8,16.4,13.55,7),lat=c(50.15,53.85,56,59.20))
sPoints    <- SpatialPoints(PointsDF,
                            proj4string=CRS("+proj=longlat +ellps=WGS84"))
sPointsUTM <- spTransform(sPoints, CRS(projection(rNDVI)))
points <- data.frame(sPointsUTM)
Germany=map_data('world',region='Germany')
GermanyLonLat <- SpatialPoints(Germany[1:2],
                               proj4string=CRS("+proj=longlat +ellps=WGS84"))
GermanyUTM <- spTransform(GermanyLonLat, CRS(projection(rNDVI)))
Germany=cbind(Germany,coordinates(GermanyUTM))
names(Germany)=c("long"     , "lat"    ,   "group" ,    "order" ,    "region" ,   "subregion" ,"x"   ,   "y")


# Lesen der NDVI Daten
NDVIDatum='2007-01-09'
file <- file.path(data.dir, 
                  paste0("MYD13A2_", NDVIDatum ,".1_km_16_days_NDVI.tif"))
rNDVI=raster(file)
dfNDVI=as.data.frame(rasterToPoints(rNDVI))
names(dfNDVI)=c('x','y','NDVI')

# Korrektur der Skalierung und Behandlung der Fehlwerte
ndviScaleFactor <- ?
ndviLowerLimit  <- ?
dfNDVI$NDVI[dfNDVI$NDVI <= ndviLowerLimit] = NA
dfNDVI$NDVI = dfNDVI$NDVI * ndviScaleFactor

# NDVI Karte mit Ländergrenzen von Deutschland und Punkten

p <- ggplot(dfNDVI, aes(x = x, y = y))
p = p + geom_raster(aes(fill = NDVI))
p = p + geom_path(data = Germany, size = 0.2, colour = "red",
                  aes(x = x, y = y, group = group))
p = p + geom_point(data = points, aes(x = long, y = lat),
                   color = "red", shape = 10, size = 2.5)
p = p + geom_text(data = points, aes(x = long, y = lat, label =
                                       paste0("P", rownames(points))),
                  hjust = c(-0.4, -0.4, 1.4, 1.4),col='red')
p = p + coord_fixed(xlim = c(min(dfNDVI$x), max(dfNDVI$x)),
                    ylim = c(min(dfNDVI$y), max(dfNDVI$y)), expand = FALSE)
p = p + theme(legend.position = "bottom")
p = p + guides(fill = guide_legend(title = NULL, ncol = 4))
p = p + labs(title = "MODIS NDVI")
p = p + xlab("Longitude")
p = p + ylab("Latitude")
p
file <- paste0("NEUROPE_NDVI_",NDVIDatum, ".pdf")
pdf(file.path(plot.dir, file), paper="special", width=10, height=10)
print(p)
dev.off()

# Lesen des NDVI für mehrere Beobachtungszeitpunkte
files <- list.files(data.dir, pattern="NDVI.tif$", full.names=TRUE)
stackNDVI <- stack(files)
# Extrahieren der Zeitreihen
dfNDVI <- extract(stackNDVI, sPointsUTM, df=TRUE)
dfNDVI$ID = NULL

#extrahieren des Datums
source('R/extractDate.R')
filenames <- colnames(dfNDVI)
ndviDate <- extractDate(filenames)

# Berechnung des Medians der Zeitreihen mit apply
ndviMid <- apply(dfNDVI, 1, "median", na.rm=TRUE)

# Datentransformation 
dfNDVI = data.frame(date=ndviDate, t(dfNDVI))

library(reshape2)
melted.dfNDVI <- melt(dfNDVI, id.vars="date")
ndviMid <- data.frame(variable=paste0("X", 1:4), median=ndviMid)

# Zeitreihenplot
folder=plot.dir
file <- "NEUROPE_NDVI.pdf"
pdf(file.path(folder, file), paper="special", width=8, height=8)
p <- ggplot(melted.dfNDVI, aes(x=date, y=value))
p <- p + geom_line()
p <- p + geom_hline(data=ndviMid, aes(yintercept=median),
                    colour="blue", linetype="dashed")
p <- p + scale_x_date()
p <- p + xlab("Datum")
p <- p + facet_wrap(~variable, ncol=1)
p <- p + ylab("NDVI")
print(p)
dev.off()