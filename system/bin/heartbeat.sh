#!/bin/env bash

#set -x

do_exit() {
    echo "$1"
    exit $2
}

do_ping() {
    ping -q -n -4 -c1 $1 > /dev/null 2>&1
    rc=$?
    return $rc
}

check_heartbeat() {
    for i in $(seq 1 "$2"); do
#        echo "Attempt $i ..."
        if do_ping "$1"; then
            return 0
        fi
    done

    return 1
}

if [[ $# -lt 1 ]]; then
    do_exit "Insufficient parameters: you must at least specify a host address" 1
fi

target="$1"
if [[ "$2" != "" ]]; then
    retries="$2"
else
    retries=4
fi
lockfile="/run/lock/heartbeat.sh@${target}"

if check_heartbeat "$target" "$retries"; then
    echo "Host ${1} is alive and well"
    rm -f $lockfile
    exit 0
else
    echo "Host ${target} is DOWN!"
    if [[ ! -f $lockfile ]]; then
        touch $lockfile
        exit 1
    else
        exit 0
    fi
fi
