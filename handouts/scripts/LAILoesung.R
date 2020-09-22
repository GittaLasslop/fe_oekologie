# ======================================================================================
# Hausaufgabe: Leaf area index (2020-06-09)
# Name: 
# Abgabe:
#
# Bitte denken Sie daran:
# - bennenen Sie dieses Template um (etwa: introduction_nachname.R)
# - laden Sie ihre Lösung bis spätestens Montag 23:59 der jeweiligen Woche ins OLAT hoch
# - das Skript soll ausführbar sein (Verzeichnisstruktur und Formatierung von Kommentaren
#   beachten) und alle geforderten Aufgaben lösen
# - falls notwendig müssen Sie zunächst externe Pakete laden
# - sollten in von uns angegebenen Beispiel-Code-Teilen Fragezeichen auftauchen so müssen
#   Sie an dieser Stelle den Code vervollständigen
# - testen Sie ihr Skript indem Sie es in RStudio aufrufen und laufen lassen
# ======================================================================================

#   Hinweis: Falls Sie Probleme mit Aufgabe 2 haben benutzen Sie den `data.frame` dfPLCTmaxLAI 
#   aus dem Skript hier für die anderen Aufgaben.
# 

#   1. Berechnen Sie den mittleren LAI für beide Jahre basierend auf den hier bereitgetstellten Dateien
#      und speichern Sie für jedes Jahr eine mit ggplot angefertigte Abbildung 
#      eine .png Datei. Benutzen Sie dafür eine For-Schleife. **(2 Punkte)**
library(raster)
library(ggplot2)
library(reshape2)
setwd('/home/gitta/R/Lehre/FE_OEKOLOGIE/fe_oekologie_2020/handouts')
data.dir <- 'data/LAI/AUS'
years <- 2010:2011
validRange <- c(0,100)
scaleFactor <- 0.1
crop_extent <- extent(c(147,153.7,-30,-24.5))
dir.create('plots/LAI')
dir.create('plots/LAI/AUS')
for (i in 1:length(years)){
  files <- list.files(data.dir, pattern=paste0("MCD15A2H_h31v11_",years[i]), full.names=TRUE)
  stackLAI <- crop(stack(files),crop_extent)
  stackLAI[stackLAI<validRange[1]] = NA
  stackLAI[stackLAI>validRange[2]] = NA
  stackLAI = stackLAI*scaleFactor
  MeanLAI = overlay(stackLAI, fun=mean)
  MeanLAIdf = as.data.frame(rasterToPoints(MeanLAI))
  names(MeanLAIdf)=c('x','y','meanLAI')
  p=ggplot(data=MeanLAIdf,aes(x=x,y=y,fill=meanLAI))
  p=p+geom_raster()
  png(paste0('plots/LAI/AUS/MeanLAI',years[i],'.png'))
  print(p)
  dev.off()
}

  
#   2. Erstellen Sie einen `data.frame` dfLCTmaxLAI, der den maximalen LAI, die Landbedeckungsklassen, 
#      sowie die Informationen zu Latitude und Longitude beinhaltet.  (Wie dfPLCTmaxLAI hier im Skript, 
#      jedoch ohne Niederschlag) **(1 Punkt)**

setwd('/home/gitta/R/Lehre/FE_OEKOLOGIE/fe_oekologie_2020/handouts')
data.dir <- 'data/LAI/AUS'
years <- 2010:2011
validRange <- c(0,100)
scaleFactor <- 0.1
crop_extent <- extent(c(147,153.7,-30,-24.5))
MaxLAI <- list()
for (i in 1:length(years)){
  files <- list.files(data.dir, pattern=paste0("MCD15A2H_h31v11_",years[i]), full.names=TRUE)
  stackLAI <- crop(stack(files),crop_extent)
  stackLAI[stackLAI<validRange[1]] = NA
  stackLAI[stackLAI>validRange[2]] = NA
  stackLAI = stackLAI*scaleFactor
  MaxLAI[[i]] = overlay(stackLAI, fun=max)
}
MaxLAIstack <- stack(MaxLAI)
MaxLAImean <- overlay(MaxLAIstack,fun=mean)
rm(stackLAI)
rm(MaxLAI)
rm(MaxLAIstack)
file <- 'data/LAI/AUS/MCD12Q1_h31v11_2010-01-01.LC_Type3.tif'
LCT <- crop(raster(file),crop_extent)
valid_range <- c(0, 253)
LCT[LCT < valid_range[1]] = NA
LCT[LCT > valid_range[2]] = NA
dfLCT <- data.frame(rasterToPoints(LCT))
names(dfLCT) = c('x','y','id')
dfLAI <- data.frame(rasterToPoints(MaxLAImean))
names(dfLAI) = c('x','y','maxLAI')
file <- 'LCT3Lookuptable.txt'
LCT3lookuptable <- read.table(file.path(data.dir, file),header=T)
dfLCT = merge(dfLCT, LCT3lookuptable, by="id", all.x=TRUE)
dfLCTmaxLAI <- merge(dfLCT,dfLAI,by=c('x','y'))


#   3. Wie können Sie sich die Anzahl der Gridzellen je Landbedeckungsklasse aus dem `data.frame` dfLCTmaxLAI 
#      ausgeben lassen? Wie groß sind die Flächen, die von den einzelnen Klassen bedeckt werden? Benutzen Sie 
#      die Information des Koordinatensystems um die Größe der Gridzelle abzuschätzen **(1 Punkt)**

hist(dfLCTmaxLAI$id)
for (i in 0:10){
  print(i)
  print(sum(dfLCTmaxLAI$id==i))
}

gridcellsPerLCT=table(dfLCTmaxLAI$name)

for (i in unique(dfLCTmaxLAI$name)){
  print(i)
  print(sum(dfLCTmaxLAI$name==i))
}

for (i in levels(dfLCTmaxLAI$name)){
  print(i)
  print(sum(dfLCTmaxLAI$name==i))
}

#   4. Violin plots bieten eine Alternative zu Histogrammen, benutzen Sie die Hilfefunktion 
#      oder das Internet um einen Violin plot mit den Landbedeckungsklassen auf der x-Achse und 
#      dem maximalen LAI auf der y-Achse zu erstellen (mit dem data.frame dfLCTmaxLAI).
#      In der Abbildung sind die Namen viel zu lang, die x-Achsen Beschriftung
#      ist dadurch nicht lesbar. Finden Sie eine Lösung für dieses Problem.  **(3 Punkte)**
#   

p = ggplot(data=dfLCTmaxLAI,aes(y=maxLAI,x=name))
p = p+geom_violin()+theme(axis.text.x = element_text(angle = 90))
p

p = ggplot(data=dfLCTmaxLAI,aes(y=maxLAI,x=name,col=name))
p = p+geom_violin()+theme(axis.text.x=element_blank(),axis.ticks.x=element_blank())
p  
# man könnte auch die spalte name noch in LCT umbenennen um eine spezifischere Beschriftung zu erzielen

#   5. Die Datei "worldclimTmeanWarmestQuarter.tif" beinhaltet das Temperaturmittel der drei wärmsten Monate eines Jahres (gemittelt 
#      über den Zeitraum 1970-2000). Lesen Sie Daten ein und kombinieren sie die Daten mit dem data.frame dfLCTmaxLAI. Stellen Sie dann 
#      den maximalen LAI als Funktion der Temperatur (unterteilt nach der Landbedeckung) dar. Wie verhält sich der LAI in Abhängigkeit 
#      von der Temperatur für die verschiedenen Landbedeckungsklassen? 
#      Beschreiben Sie den erstellten Scatterplot! Welche Unterschiede zwischen den Vegetationsklassen fallen Ihnen auf? **(2 Punkte)** 

Temp <- raster(file.path(data.dir,'worldclimTmeanWarmestQuarter.tif'))
Temp <- resample(Temp,LCT)
dfTemp <- data.frame(rasterToPoints(Temp))
names(dfTemp) = c('x','y','Temperature')
dfTLCTmaxLAI <- merge(dfTemp,dfLCTmaxLAI,by=c('x','y'))
ind <- which(dfTLCTmaxLAI$name=='Water'|dfTLCTmaxLAI$name=='Non-vegetated')
dfTLCTmaxLAI = dfTLCTmaxLAI[-ind,]
p <- ggplot(data=dfTLCTmaxLAI, aes(x=Temperature, y=maxLAI))
p = p + facet_wrap(~name)
p = p + xlab("Temperatur wärmstes Quartal [°C]")
p = p + ylab("Maximaler LAI [m2/m2]")
p = p + geom_hex(bins=50)
p = p + geom_smooth(se=TRUE)
png('plots/LAI/AUS/LAI_Temp.png')
print(p)
dev.off()
#fuer die Klassen Evergreen Boradleaf Forest, Grasses/Cereal crops, Savanna und Shrubs sinkt der maximale LAI bei besonders hohen mittleren Temperaturen im waermsten Quartal (Sommer)
#in Australien haben hohe Sommertemperaturen offensichtlich einen negativen Einfluss auf das Pflanzenwachstum (eventuell niedrigere Photosynthese durch hohe Transpiration; hohe Respiration; hohe Mortalitaet)
#fuer die anderen Klassen ist die Datenlage nicht ausreichend fuer Rueckschluesse



