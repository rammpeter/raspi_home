#!/bin/bash

# Zur zyklischen Ausführung in cron etc.

# Da cron die .profile nicht inkludiert, hier nachholen, explizit bash setzen vorher
. /home/pi/.profile

DIR=`dirname $0`
cd $DIR

LOG=log/schreibe_temperatur.log

bin/rails runner -e production "Temperatur.schreibe_temperatur(18,20)" 2>>$LOG >>$LOG
RC=$?

if [ $RC -ne 0 ]; then
  echo `date`  >> $LOG
  echo "Fehler bei Ausführung Temperatur.schreibe_temperatur" >> $LOG
  echo "RC=$RC" >> $LOG
fi
exit $RC
