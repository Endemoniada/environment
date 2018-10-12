#!/bin/bash
if [[ ! -f /var/tmp/clean_boot ]]; then
	echo "System was not shut down cleanly!"
	echo "Please investigate cause for shut down."
	exit 1
else
	rm /var/tmp/clean_boot && exit 0
fi
exit 1
