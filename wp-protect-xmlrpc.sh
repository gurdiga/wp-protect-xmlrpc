#!/bin/bash

set -e

LOG_FILE=/var/log/apache2/access.log

grep 'xmlrpc.php' $LOG_FILE | \
awk '{ print $1 }' | \
sort | \
uniq -c | \
while read count ip; do
	if [ $count -gt 100 ]; then
		echo "$ip has made $count requests"
	fi
done
