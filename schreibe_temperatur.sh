# Zur zyklischen Ausführung in cron etc.

DIR=`dirname $0`
cd $DIR

rails runner -e production "Temperatur.schreibe_temperatur"
