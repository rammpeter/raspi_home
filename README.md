Swimming-Pool: Steuerung der Umwälzpumpe für Solaranlage mit Raspberry-Pi
========

Ziel des Projektes ist die Steuerung einer Pool-Anlage mit Umwälzpumpe, Filter und Solarheizung so,
dass die Sonnenenergie der Solaranlage optimal ausgenutzt wird zur Erwärmung des Pools.

Im ersten Schritt war geplant, sowohl die Umwälzpumpe als auch das 3-Wege-Ventil zur Einbindung bzw. Überbrückung der Solaranlage zu steuern.
Auf Grund der physikalisch schwierigen Ansteuerung des 3-Wege-Ventils beschränkt sich das Projekt aktuell auf die Steuerung der Umwälzpumpe.

Folgende Prämissen sollen erfüllt werden:

1. Dauerbetrieb der Umwälzpumpe nur, wenn über die Solaranlage auch die Beckentemperatur wirklich erhöht wird und nicht Energie des Beckenwassers wieder an die Umwelt abgegeben wird

2. Eine Mindestumwälzdauer über mehrere Tage sollte eingehalten werden, auch wenn wegen Witterung diese nicht durch Betrieb nach Punkt 1 sichergestellt werden kann.

3. Auch wenn kein Betrieb nach Punkt 1 aktiviert ist, soll zyklisch die Pumpe kurz eingeschalten werden, um Oberflächenschmutz in den Skimmer zu befördern

Da für die Steuerung je Minute Werte für dioe Außentemperatur in der Sonne und im Schatten aufgenommen werden,
fällt nebenbei noch die Funktion einer Wtterstattion mit langfristiger Protokollierung der Temperaturen mit ab.

<b>Denkbare Erweiterungen</b>
- Messung Clor-Gehalt / ph-Wert und Benachrichtigung bei notwendigem Eingreifen
- Steuerung Gewächshaus
- Frostwarnung / Warnung bei Unter/Überschreiten von Temperaturgrenzen

