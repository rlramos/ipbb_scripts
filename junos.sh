#!/bin/bash
# type hostname:port e.g. bb01.sjc1:et-0/0/3

echo""
echo "Pulling interface status, transceiver levels and hardware information"
echo""

HOST=`echo $1 | awk -F ":" '{print $1}'`
PORT=`echo $1 |awk -F ":" '{print$2""$3;}'`
#echo $HOST
#echo $PORT

SCRIPT="show chassis hardware ; show interfaces diagnostics optics ${PORT} ; show interfaces ${PORT} | match \"last|link|err|desc\" ;"
#echo $SCRIPT

ssh $HOST "$SCRIPT"
