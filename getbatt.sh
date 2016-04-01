#!/bin/bash

# Get battery percentage
battpercent=$(pmset -g batt | grep 'Battery-0' | awk -F';' '{ print $1 }' | awk -F' ' '{ print $2 }')

# Get power source
powersource=$(pmset -g batt | grep 'Now drawing from' | awk -F"'" '{ print $2 }')

# Get battery status
battstatus=$(pmset -g batt | grep 'Battery-0' | awk -F';' '{ print $2 }' | awk -F' ' '{ print $1 }')

# Get remaining charge/battery time
remtime=$(pmset -g batt | grep 'Battery-0' | awk -F';' '{ print $3 }' | awk -F' ' '{ print $1" "$2 }')

echo -n "$powersource $battpercent"
if [[ $battstatus != "charged" ]]; then
	echo " $remtime"
else
	echo ""
fi
exit 0
