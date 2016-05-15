#!/bin/bash

# Zur Aktualisierung des Systems ausführen im Apllikations-Verzeichnis
RC=0

# Aktualisierung der Software
git pull

# Abhängigkeiten nachladen
bundle install

# Anpassung der Datenbank an aktuelle Software
rake db:migrate

# Neustart des Webservers
sudo /etc/init.d/ramm stop
sudo /etc/init.d/ramm start

exit $RC
