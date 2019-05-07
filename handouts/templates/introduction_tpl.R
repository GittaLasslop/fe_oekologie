# ======================================================================================
# Hausaufgabe: Einführung (2019-05-07)
# Name: 
# Abgabe:
#
# Bitte denken Sie daran:
# - bennenen Sie dieses Template um (etwa: introduction_nachname.R)
# - laden Sie ihre Lösung bis spätestens Sonntag 23:59 der jeweiligen Woche ins OLAT hoch
# - das Skript soll ausführbar sein (Verzeichnisstruktur und Formatierung von Kommentaren
#   beachten) und alle geforderten Aufgaben lösen
# - falls notwendig müssen Sie zunächst externe Pakete laden
# - sollten in von uns angegebenen Beispiel-Code-Teilen Fragezeichen auftauchen so müssen
#   Sie an dieser Stelle den Code vervollständigen
# - testen Sie ihr Skript indem Sie es in RStuio aufrufen und laufen lassen
# ======================================================================================

# Aufgabe 0: ---------------------------------------------------------------------------
# a) Erstellen Sie einen data.frame "Tabelle1" mit den Spalten “Latitude”, “Longitude”, 
# “Landcover”. Die Spalte “Landcover” soll den Typ Faktor haben.
# lat = c(50.11, 23.9, 50.2) lon = c(8.68, 32.9, 8.2) lu = c(“urban”, “water”, “forest”)
# Geben Sie den erstellten data.frame aus und führen Sie außerdem den Befehl 
# summary() aus: "summary(Tabelle1)"


# b) Erstellen Sie einen data.frame “Tabelle2” mit den Spalten “Latitude”, “Longitude”, 
# “Landcover”. Die Spalte “Landcover” soll den Typ Faktor haben.
# lat = c(50.11, 23.9, 50.2, 0.0) lon = c(8.68, 32.9, 8.2, -10.5) lu = c(“urban”, “water”)
# Geben Sie den erstellten data.frame aus und führen Sie außerdem den Befehl summary aus: 
# summary(Tabelle2). Was fällt Ihnen auf?


# Aufgabe 1: --------------------------------------------------------------------------- 
# Erstellen Sie einen data.frame KohlenstoffSpeicher mit den Spalten Ökosystem, 
# Vegetation und Boden. Tragen sie in der Ökosystemspalte drei verschiedene Namen
# für Ökosysteme ein, in der zweiten und dritten Spalte numerische Werte für
# Vegetations- und Bodenkohlenstoffspeicher. Geben Sie den data.frame mit print() aus.


# Aufgabe 2: ---------------------------------------------------------------------------
# Der data.frame Geburtstag enthält die Geburtstagsdaten von Einstein, Humboldt
# und Darwin. Greifen Sie auf die einzelnen Zeilen zu und speichern Sie sie in
# chronologischer Reihenfolge in einem von Ihnen erstellten data.frame Geburtstag2.
# Berechnen Sie wieviele Tage Albert Einstein nach Charles Darwin geboren wurde, 
# indem Sie auf die einzelnen Einträge im data.frame zugreifen.

Geburtstag=data.frame(Person=c('Albert Einstein','Alexander von Humboldt','Charles Darwin'), 
                      Day=c(14,14,12),
                      Month=c(3,9,2),
                      Year=c(1879,1769,1809))

# Aufgabe 3: ---------------------------------------------------------------------------
# Berechnen Sie die Quadratwurzel der Zahlen 1 bis 10 mit einer for-Schleife.


# Aufgabe 4: ---------------------------------------------------------------------------
# Schreiben Sie eine Funktion zur Berechnung der Fläche eines Kreises. Eingabeparameter
# soll der Radius sein. Rückgabewert soll die Fläche sein.


# Aufgabe 5: --------------------------------------------------------------------------- 
# Schreiben Sie einen R Code mit einer Variablen Uhrzeit, der für den Wert '9 Uhr' der
# Variablen den Text 'Guten Morgen' zurückgibt, für den Wert '18 Uhr' den Text 'Guten Abend'.


# Aufgabe 6: ---------------------------------------------------------------------------  
# Erstellen Sie einen Funktion die ein Argument als Eingabe erwartet und folgende Funktionalität
# besitzt. Für Werte kleiner als 0 soll "ungültig", für Werte von 1-4 soll "sehr wenig", 
# für Werte von 5-10 "wenig", für Werte von 10-100 "viel" und für alle Werte größer als 100
# "sehr viel" zurückgegeben werden.

meine_bewertung <- function(x){
  # hier kommt ihr Kontrollfluss hin
  
  return(bewertung)
}

# hier führen Sie die Funktion meine_bewertung mit  Beispielwert aus
meine_bewertung(12)
meine_bewertung(-23)
# ...

