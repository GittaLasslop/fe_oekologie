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
# 1) Lesen Sie die Daten aus der Datei ErsteDatencR.txt ein und fertigen Sie eine 
# Abbildung der Zeitreihe der mittleren Temperatur an. Wandeln Sie hierfür das Datum mit 
#Daten$Datum=as.Date(Daten$Datum,"%d.%m.%Y") 
#in den speziellen Datentyp für Zeit- und Datumvariablen um.
#Rufen Sie die Hilfe für die plot-Funktion auf (?plot). Schauen Sie sich die Beschreibung 
#der Argumente an, die an die Funktion übergeben werden können.
#Ändern Sie nun die folgenden Dinge in der Abbildung:
  
# * plotten Sie statt Punkten eine Linie mit Punkten
# * fügen Sie eine Überschrift 'Mittlere Temperatur' hinzu und eine Unter-Überschrift 'in Frankfurt' hinzu
# * beschriften Sie x- und y-Achse indem Sie die Parameter xlab und ylab mit sinnvollen Beschriftungen übergeben.

# Speichern Sie die Abbildungen als png-Dateien ab.

#2) Benutzen Sie google um herauszufinden wie Sie die Farbe der Punkte oder Linie ändern können.
# Welche Suchanfrage bringt Ihnen die Lösung? Fertigen Sie die Abbildung aus Aufgabe 1 mit roten
# Punkten an und speichern Sie sie als png-Datei.

# 3) Schreiben Sie eine Funktion zur Berechnung der Fläche eines Kreises names 'Kreisflaeche'. 
# Eingabeparameter soll der Durchmesser sein. Rückgabewert soll die Fläche sein. 
# Berechnen Sie durch einen Funktionsaufruf die Fläche eine Kreises mit Radius 1 und 
# geben Sie das Ergebnis mit print() aus.

Funktionsname <- function(inputParameter) {
  # Fügen Sie hier die Berechnung ein:
  
  return(Rückgabewert)
}


#4). Erstellen Sie eine Funktion meine_bewertung die ein Argument als Eingabe erwartet 
# und folgende Funktionalität besitzt. Für Werte kleiner als 0 soll "ungültig", für Werte
# von 1-2 soll "sehr wenig", für Werte von 3-15 "wenig", für Werte von 16-200 "viel" und 
# für alle Werte größer als 200 "sehr viel" zurückgegeben werden. 


meine_bewertung <- function(x){
  # hier kommt ihr Kontrollfluss hin
  
  return(bewertung)
}

# test der funktion
print(meine_bewertung(12))
print(meine_bewertung(-23))
# ...
