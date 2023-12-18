#!/bin/bash
#set -x

arista=0
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
COMMUNITY="4m0nTFB"
if [ "$#" -ne 1 ]; then
		exit
else

# psw01.sea1:Ethernet3/1/1
HOST=`echo $1 | awk -F ":" '{print $1}'`
PORT=`echo $1 | awk -F ":" '{if (NF==3) print$2":"$3; if (NF==2) print $2;}'`
#echo $HOST
#echo $PORT

if [ `echo $PORT | grep 'Ethernet' -c` -ge 1 ]; then
	arista=1
	HOST_O="$HOST"
	HOST=`dig ${HOST}.tfbnw.net AAAA +short`
fi
if [ `echo $PORT | grep -E '(et-|ge-|xe-|Ethernet)' -c` -ge 1 ]; then
	#echo "Juniper"
	req='ifName'
	snmpifOID=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} IF-MIB::${req} -Oe -OQ -Ot -OU | grep ${PORT}$ | awk -F ' = ' '{print $1}' | awk -F "${req}." '{print $2}'`
	#echo "iface oid: "${snmpifOID}
	req="ifOperStatus"
	snmpifOperStatus=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} IF-MIB::${req}.${snmpifOID}  -OQ -Ot -OU | awk -F ' = ' '{print $2}'`
	# + snmpifOperStatus=up

	req="ifLastChange"
	snmpifLastChange=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} IF-MIB::${req}.${snmpifOID}  -Oe -OQ -Ot -OU | awk -F ' = ' '{print $2}'`

	req="sysUpTime"
  snmpsysUpTime=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} ${req}  -Oe -OQ -Ot -OU | awk -F ' = ' '{print $2}'`

	ifaceUptime_h=$((($snmpsysUpTime - $snmpifLastChange) / 3600))
	if [ $ifaceUptime_h -ge 8 ] && [ $snmpifOperStatus == "up" ]; then
		printf $GREEN
	elif [ $snmpifOperStatus != "up" ]; then
		printf $RED
fi
	if [ $arista == 1 ]; then
		  echo $HOST_O:$PORT "is" ${snmpifOperStatus}, "last flap: ${ifaceUptime_h}h"
	else
		echo $HOST:$PORT "is" ${snmpifOperStatus}, "last flap: ${ifaceUptime_h}h"
	fi
printf $NC
fi

#echo $HOST
#echo $PORT
fi
#!/bin/bash
#set -x

arista=0
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
COMMUNITY="4m0nTFB"
if [ "$#" -ne 1 ]; then
		exit
else
HOST=`echo $1 | awk -F ":" '{print $1}'`
PORT=`echo $1 | awk -F ":" '{if (NF==3) print$2":"$3; if (NF==2) print $2;}'`
#echo $HOST
#echo $PORT

if [ `echo $PORT | grep 'Ethernet' -c` -ge 1 ]; then
	arista=1
	HOST_O="$HOST"
	HOST=`dig ${HOST}.tfbnw.net AAAA +short`
fi

while true
do
if [ `echo $PORT | grep -E '(et-|ge-|xe-|Ethernet)' -c` -ge 1 ]; then
	#echo "Juniper"
	req='ifName'
	snmpifOID=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} IF-MIB::${req} -Oe -OQ -Ot -OU | grep ${PORT}$ | awk -F ' = ' '{print $1}' | awk -F "${req}." '{print $2}'`
	#echo "iface oid: "${snmpifOID}i


	req="ifOperStatus"
	snmpifOperStatus=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} IF-MIB::${req}.${snmpifOID}  -OQ -Ot -OU | awk -F ' = ' '{print $2}'`
	# + snmpifOperStatus=up

	req="ifLastChange"
	snmpifLastChange=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} IF-MIB::${req}.${snmpifOID}  -Oe -OQ -Ot -OU | awk -F ' = ' '{print $2}'`

	req="sysUpTime"
  snmpsysUpTime=`snmpbulkwalk -c ${COMMUNITY} -v 2c ${HOST} ${req}  -Oe -OQ -Ot -OU | awk -F ' = ' '{print $2}'`

	ifaceUptime_h=$(((($snmpsysUpTime-$snmpifLastChange)/100)/60/60))
	ifaceUptime_m=$(((($snmpsysUpTime-$snmpifLastChange)/100)/60))
  ifaceUptime_s=$(((($snmpsysUpTime-$snmpifLastChange)/100)))
if [ $ifaceUptime_h -ge 8 ] && [ $snmpifOperStatus == "up" ]; then
		printf $GREEN
	elif [ $snmpifOperStatus != "up" ]; then
		printf $RED
  fi
	if [ $arista == 1 ]; then
		  echo $HOST_O:$PORT "is" ${snmpifOperStatus}, "last flap: ${ifaceUptime_h}h (${ifaceUptime_s} sec) ago"
	else
		echo $HOST:$PORT "is" ${snmpifOperStatus}, "last flap: ${ifaceUptime_h}h (${ifaceUptime_s} sec) ago"
	fi
  printf $NC

fi
done

#echo $HOST
#echo $PORT
fi
