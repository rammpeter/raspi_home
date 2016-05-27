#!/bin/bash

# Zur zyklischen Ausführung in cron etc.

# Da cron die .profile nicht inkludiert, hier nachholen, explizit bash setzen vorher
. /home/pi/.profile

DIR=`dirname $0`
cd $DIR

LOG=log/schreibe_temperatur.log

# Einstellungen fuer Temperaturfuehler Garage Ramm
# Sensor für Vorlauf misst 0,06 Grad mehr (Serienstreuung)
#export FILENAME_VORLAUF=/sys/bus/w1/devices/28-04146f57a7ff/w1_slave
#export FILENAME_RUECKLAUF=/sys/bus/w1/devices/28-04146f57bdff/w1_slave
#export FILENAME_SCHATTEN=/sys/bus/w1/devices/28-021503c981ff/w1_slave
#export FILENAME_SONNE=/sys/bus/w1/devices/28-021503c262ff/w1_slave

# Einstellungen für per LAN schaltbare Steckdose
#export SCHALTER_TYP=Rutenbeck_TPIP1
#export SCHALTER_IP=192.168.178.48

bin/rails runner -e production "Temperatur.schreibe_temperatur" 2>>$LOG >>$LOG
RC=$?

if [ $RC -ne 0 ]; then
  echo `date`  >> $LOG
  echo "Fehler bei Ausführung Temperatur.schreibe_temperatur" >> $LOG
  echo "RC=$RC" >> $LOG
fi
exit $RC
