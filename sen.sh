#!/bin/bash

PDU=$1

fcr --commands="senstat" --device=$PDU --no-regex_search_skynet
