#!/bin/bash

# sample crontab record
#
# */10 * * * * wp-protect-xmlrpc/wp-protect-xmlrpc.sh

set -e

LOG_FILE="/var/log/apache2/access.log"
ANCHOR_TEXT="POST /xmlrpc.php"
MAX_REQUESTS="100"

function scan_log() {
        log_file="$1"

        grep -F "$ANCHOR_TEXT" "$log_file" | \
        cut -d ' ' -f 1 | \
        sort | \
        uniq -c | \
        while read request_count ip; do
                if [ $request_count -gt $MAX_REQUESTS ]; then
                        if ! already_banned $ip; then
                                echo "$ip has made $request_count requests, will block"
                                ban $ip
                        fi
                fi
        done
}

function already_banned() {
        ip="$1"

        /sbin/iptables -n -L | \
        grep --silent "DROP .* $ip"
}

function ban() {
        ip="$1"

        /sbin/iptables -A INPUT -s $ip -j DROP
}

scan_log $LOG_FILE
