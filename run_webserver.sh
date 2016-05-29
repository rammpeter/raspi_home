#!/bin/bash

# Zum Starten des Webservers

# Da cron die .profile nicht inkludiert, hier nachholen, explizit bash setzen vorher
. /home/pi/.profile

DIR=`dirname $0`
cd $DIR

LOG=log/run_weserver.log
export SECRET_KEY_BASE=64bf00b2119874a10459a3858e4fa9659fe98418587f7a3904bd1ac6548055befdb269ba6c2e5b508fd99442140a8d16bd14b4145b7d4e5e2986524018570607

bin/rails server -e production --binding 0.0.0.0 2>>$LOG >>$LOG
RC=$?

if [ $RC -ne 0 ]; then
  echo `date`  >> $LOG
  echo "Fehler bei Ausführung bin/rails server -e production --binding 0.0.0.0" >> $LOG
  echo "RC=$RC" >> $LOG
fi
exit $RC
