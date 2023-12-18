#!/bin/bash
# ./pw <username>:<host>

username=$1
host=$2

rotor_cli getpassword --namespace neteng -e $username@$host
rotor_cli gethistory --namespace neteng -e $username@$host
