# ======================================================================================
# Hausaufgabe: Einführung (2019-05-07)
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
# - testen Sie ihr Skript indem Sie es in RStuio aufrufen und laufen lassen
# ======================================================================================


# Aufgabe 1: --------------------------------------------------------------------------- 
#1. Wie finden Sie die Eigenschaften des Koordinatensystems von raster Objekten heraus? **(1 Punkt)**

# Aufgabe 2: ----------------------------------------------------------------------------
# Schauen Sie sich die Hilfe zur Funktion apply an um zu verstehen was in der folgenden Zeile passiert:
# ndviMid <- apply(dfNDVI, 1, "median", na.rm=TRUE)

#  Was passiert wenn Sie als zweiten Parameter statt 1 eine 2 übergeben? **(1 Punkt)**
  
#  Wie können Sie das Maximum jeder Spalte des data.frames mit der Funktion apply berechnen? **(1 Punkt)**
  
#  Was bewirkt die Übergabe des Parameters na.rm=TRUE? **(1 Punkt)**
  
  
# Aufgabe 3: -----------------------------------------------------------------------------
# Schauen Sie sich den folgenden code zur Erstellung der Abbildung mit ggplot genauer an:
  
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
p = p + labs(title = "MODIS NDVI")
p = p + xlab("Longitude")
p = p + ylab("Latitude")
p


#  I.) Aendern Sie in den abgebildeten Kartenausschnitt so dass nur der Bereich bis Latitude 6250000 gezeigt wird. **(1Punkt)**
  
#  II.) Setzen Sie die Legende statt unter die Abbildung über die Abbildung.  **(1 Punkt)**
  
#  III.) Aendern Sie die Farbe der Punkte **(1 Punkt)**
  
#  IV.) Aendern Sie die Dicke der Ländergrenze. **(1 Punkt)**
  
#  Sie müssen dafür lediglich den oben stehenden code abändern. Probieren Sie einfach Parameteränderungen aus
# oder rufen Sie die Hilfeseiten für die einzelnen Befehle auf, oder googlen Sie.

# Aufgabe 4: ---------------------------------------------------------------
# Wir werden in den nächsten Stunden noch häufiger eine Datei einlesen und sie in einen data.frame umwandeln. 
# Schreiben Sie daher eine Funktion für die folgende Prozedur:

NDVIDatum='2007-01-09'
file <- file.path('data/PHEN/NEUROPE/', 
                  paste0("MYD13A2_", NDVIDatum ,".1_km_16_days_NDVI.tif"))
name='NDVI'
rData=raster(file)
dfData=as.data.frame(rasterToPoints(rData))
names(dfData)=c('x','y',name)

# Die Variablen file und name sollen an die Funktion übergeben werden, die Variable dfData 
# soll aus der Funktion zurückgegeben werden. Die Funktion soll `geotiff2df` heißen. Zur Erinnerung 
# hier nochmal die allgemeine Form einer Funktion in R:
  
# Funktionsname <- function(inputParameter) {
#  # Fügen Sie hier die Berechnung ein:
#  
#  return(RückgabeParameter)
# }

# **(3 Punkte)**
