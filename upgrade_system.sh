#!/bin/bash

# Zur Aktualisierung des Systems ausführen im Applikations-Verzeichnis auf dem Raspi
RC=0

# Durch vprhergehendes bundle install geändertes File entfernen
rm Gemfile.lock

# Aktualisierung der Software
git pull

# Abhängigkeiten nachladen
bundle install

# Anpassung der Datenbank an aktuelle Software
export RAILS_ENV=production
rake db:migrate

# Neustart des Webservers
sudo /etc/init.d/raspi_home stop
sudo /etc/init.d/raspi_home start

exit $RC
