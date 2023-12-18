#!/bin/bash

ticket=`echo $1 | awk -F "nwt" '{print $2}'`
resortcli get ticket_number=$ticket
