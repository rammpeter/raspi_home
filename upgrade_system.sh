#!/bin/bash

# Zur Aktualisierung des Systems
RC=0

# Aktualisierung der Software
git pull

# Anpassung der Datenbank an aktuelle Software
rake db:migrate

# Neustart des Webservers
sudo /etc/init.d/ramm stop
sudo /etc/init.d/ramm start

exit $RC
