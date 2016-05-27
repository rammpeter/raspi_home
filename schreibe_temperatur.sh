#!/bin/bash

# Zur zyklischen Ausführung in cron etc.

# Da cron die .profile nicht inkludiert, hier nachholen, explizit bash setzen vorher
. /home/pi/.profile

DIR=`dirname $0`
cd $DIR

LOG=log/schreibe_temperatur.log
T_LOG=log/schreibe_temperatur_temp.log

bin/rails runner -e production "Temperatur.schreibe_temperatur" 2>>$T_LOG >>$T_LOG
RC=$?

cat $T_LOG |  grep -v 'Running via Spring preloader in process' >> $LOG
rm $T_LOG

if [ $RC -ne 0 ]; then
  echo `date`  >> $LOG
  echo "Fehler bei Ausführung Temperatur.schreibe_temperatur" >> $LOG
  echo "RC=$RC" >> $LOG
fi
exit $RC
