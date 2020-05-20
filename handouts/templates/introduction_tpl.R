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
# Erstellen Sie einen data.frame KohlenstoffSpeicher mit den Spalten Ökosystem, 
# Vegetation und Boden. Tragen sie in der Ökosystemspalte drei verschiedene Namen
# für Ökosysteme ein, in der zweiten und dritten Spalte numerische Werte für
# Vegetations- und Bodenkohlenstoffspeicher. Geben Sie den data.frame mit print() aus.
Kohlenstoffspeicher = data.frame(Oekosystem=c('Wald','Acker','Wiese'),Vegetation=c(4,2.4,7.6),Boden=c(2,2,2))
print(Kohlenstoffspeicher)
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
print(Geburtstag)


Geburtstag2 = data.frame(Geburtstag[order(Geburtstag$Year),])
print(Geburtstag2)

#Berechnung der Altersdifferenz zwischen Albert Einstein und Charles Darwin:
schaltjahre = 17
(Geburtstag2[3,4]-Geburtstag2[2,4])*365 + (Geburtstag2[3,3]-Geburtstag2[2,3])*28 + (Geburtstag2[3,2]-Geburtstag2[2,2] + schaltjahre)

# Aufgabe 3: ---------------------------------------------------------------------------
# Berechnen Sie die Quadratwurzel der Zahlen 1 bis 10 mit einer for-Schleife.
for(i in 1:10){
  print(sqrt(i))
}

for(i in 1:10){
  print(i^0.5)
}

# Aufgabe 4: --------------------------------------------------------------------------- 
# Schreiben Sie einen R Code mit einer Variablen Uhrzeit, der für den Wert '9 Uhr' der
# Variablen den Text 'Guten Morgen' zurückgibt, für den Wert '18 Uhr' den Text 'Guten Abend'.

Uhrzeit='18 Uhr'
if (Uhrzeit == '9 Uhr'){
  print('Guten Morgen')
}else if(Uhrzeit == '18 Unr'){
  print('Guten Abend')
}
