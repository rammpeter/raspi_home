#!/bin/bash

# Zur zyklischen Ausführung in cron etc.

# Da cron die .profile nicht inkludiert, hier nachholen, explizit bash setzen vorher
. /home/pi/.profile

DIR=`dirname $0`
cd $DIR

LOG=$DIR/log/schreibe_temperatur.log

COMMAND="rails runner -e production 'Temperatur.schreibe_temperatur'"
$COMMAND 2>>$LOG >>$LOG
RC=$?

if [ $RC -ne 0 ]; then
  echo `date`  >> $LOG
  echo "Fehler bei Ausführung $COMMAND" >> $LOG
  echo "RC=$RC" >> $LOG
fi
exit $RC
