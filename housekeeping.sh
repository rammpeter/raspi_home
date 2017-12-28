#!/bin/bash

# Zur zyklischen Ausführung in cron etc.

# Da cron die .profile nicht inkludiert, hier nachholen, explizit bash setzen vorher
. /home/pi/.profile

DIR=`dirname $0`
cd $DIR

LOG=~/log/housekeeping.log

bin/rails runner -e production "Temperatur.housekeeping" 2>>$LOG >>$LOG
RC=$?

if [ $RC -ne 0 ]; then
  echo `date`  >> $LOG
  echo "Fehler bei Ausführung Temperatur.housekeeping" >> $LOG
  echo "RC=$RC" >> $LOG
fi
exit $RC
