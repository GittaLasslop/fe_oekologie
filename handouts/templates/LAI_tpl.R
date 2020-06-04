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
  
#   2. Erstellen Sie einen `data.frame` dfLCTmaxLAI, der den maximalen LAI, die Landbedeckungsklassen, 
#      sowie die Informationen zu Latitude und Longitude beinhaltet.  (Wie dfPLCTmaxLAI hier im Skript, 
#      jedoch ohne Niederschlag) **(1 Punkt)**


#   3. Wie können Sie sich die Anzahl der Gridzellen je Landbedeckungsklasse aus dem `data.frame` dfLCTmaxLAI 
#      ausgeben lassen? Wie groß sind die Flächen, die von den einzelnen Klassen bedeckt werden? Benutzen Sie 
#      die Information des Koordinatensystems um die Größe der Gridzelle abzuschätzen **(1 Punkt)**

#   4. Violin plots bieten eine Alternative zu Histogrammen, benutzen Sie die Hilfefunktion 
#      oder das Internet um einen Violin plot mit den Landbedeckungsklassen auf der x-Achse und 
#      dem maximalen LAI auf der y-Achse zu erstellen (mit dem data.frame dfLCTmaxLAI).
#      In der Abbildung sind die Namen viel zu lang, die x-Achsen Beschriftung
#      ist dadurch nicht lesbar. Finden Sie eine Lösung für dieses Problem.  **(3 Punkte)**
#   


#   5. Die Datei "worldclimTmeanWarmestQuarter.tif" beinhaltet das Temperaturmittel der drei wärmsten Monate eines Jahres (gemittelt 
#      über den Zeitraum 1970-2000). Lesen Sie Daten ein und kombinieren sie die Daten mit dem data.frame dfLCTmaxLAI. Stellen Sie dann 
#      den maximalen LAI als Funktion der Temperatur (unterteilt nach der Landbedeckung) dar. Wie verhält sich der LAI in Abhängigkeit 
#      von der Temperatur für die verschiedenen Landbedeckungsklassen? 
#      Beschreiben Sie den erstellten Scatterplot! Welche Unterschiede zwischen den Vegetationsklassen fallen Ihnen auf? **(2 Punkte)** 



