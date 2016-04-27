#!/bin/bash

set -e

function scan_log() {
	log_file="$1"

	grep -F 'xmlrpc.php' "$log_file" | \
	awk '{ print $1 }' | \
	sort | \
	uniq -c | \
	while read count ip; do
		if [ $count -gt 100 ]; then
			if [ ! already_banned $ip ]; then
				echo "$ip has made $count requests"
			fi
		fi
	done
}

function already_banned() {
	ip="$1"

	iptables -L | \
	grep --silent "DROP .* $ip"
}

#scan_log /var/log/apache2/access.log
