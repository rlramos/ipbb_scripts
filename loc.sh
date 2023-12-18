#!/bin/bash

device=$1

serf get --fields name,serial_number,asset_tag,suite,row,rack,rack_position,make,model,datacenter name=$device
