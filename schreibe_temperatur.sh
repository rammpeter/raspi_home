#!/bin/bash

# Zur zyklischen Ausführung in cron etc.

# Da cron die .profile nicht inkludiert, hier nachholen, explizit bash setzen vorher
. /home/pi/.profile

DIR=`dirname $0`
cd $DIR

LOG=~/log/schreibe_temperatur.log
T_LOG=~/log/schreibe_temperatur_temp.log
touch $T_LOG

export SECRET_KEY_BASE=64bf00b2119874a10459a3858e4fa9659fe98418587f7a3904bd1ac6548055befdb269ba6c2e5b508fd99442140a8d16bd14b4145b7d4e5e2986524018570607

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
