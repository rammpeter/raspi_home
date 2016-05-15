#!/bin/bash

# Zur Aktualisierung des Systems ausführen im Applikations-Verzeichnis auf dem Raspi
RC=0

# Aktualisierung der Software
git pull

# Abhängigkeiten nachladen
rm Gemfile.lock
bundle install

# Anpassung der Datenbank an aktuelle Software
export RAILS_ENV=production
rake db:migrate

# Neustart des Webservers
sudo /etc/init.d/ramm stop
sudo /etc/init.d/ramm start

exit $RC
