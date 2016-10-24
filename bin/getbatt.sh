#!/bin/bash

# Get battery percentage
battpercent=$(pmset -g batt | grep 'Battery-0' | awk -F';' '{ print $1 }' | awk -F' ' '{ print $3 }')

# Get power source
powersource=$(pmset -g batt | grep 'Now drawing from' | awk -F"'" '{ print $2 }' | awk -F' ' '{ print $1 }' | head -c 4)

# Get battery status
battstatus=$(pmset -g batt | grep 'Battery-0' | awk -F';' '{ print $2 }' | awk -F' ' '{ print $1 }')

# Get remaining charge/battery time
remtime=$(pmset -g batt | grep 'Battery-0' | awk -F';' '{ print $3 }' | awk -F' ' '{ print $1 }')

echo -n "$powersource"
if [[ $battpercent != "100%" ]]; then
	echo -n " $battpercent"
fi
if [[ $battstatus != "charged" ]]; then
	echo -n " $remtime"
fi
echo ""
exit 0
