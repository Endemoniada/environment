#!/bin/bash

# Get battery percentage
battpercent=$(pmset -g batt | grep 'Battery-0' | awk -F';' '{ print $1 }' | awk -F' ' '{ print $2 }')

# Get power source
powersource=$(pmset -g batt | grep 'Now drawing from' | awk -F"'" '{ print $2 }')

echo "$powersource $battpercent"
exit 0
