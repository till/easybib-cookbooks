#!/bin/bash
# Script: rds-test
# Description: Iteratively curl the rds-test.php script and log the output.
# Author: Brian Wiborg <b.wiborg@chegg.com>
#
# Usage: rds-test [<seconds>] [<hostname>] [<logfile>]
#
# Arguments:
# - seconds     - Exit in n seconds (default: 60)
# - hostname    - The HTTP header host (default: rds.test)
# - logfile     - Which file to log to (default: /var/log/rds.log)

seconds="${1:-60}"
hostname="${2:-rds.test}"
logfile="${3:-/var/log/rds.log}"
num_lines=0

function log() {
	timestamp="$(date +%Y-%m-%d_%H:%M:%S.%N)"
	echo $timestamp $@ >> "$logfile"
	echo $timestamp $@
}

function kill() {
    log "interrupted. (Seconds: $SECONDS, Requests: $num_lines, Logfile: $logfile)"
    exit 1
}

log "starting! (Seconds: $seconds, Host: $hostname, Logfile: $logfile)"
trap kill INT TERM
sleep 2

while true; do
    if (( SECONDS >= seconds )); then
        log "done. (Seconds: ${SECONDS}, Requests: $num_lines, Logfile: $logfile)"
        exit 0
    fi

    log $(curl -H "Host: $hostname" localhost/rds-test.php 2>/dev/null)
    ((num_lines++))
done

