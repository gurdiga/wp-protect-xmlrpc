# The Big Idea®

Today I found one of my WordPress websites bogged down by calls to
`/xmlrpc.php`. This is a little script that looks into Apache log and
blocks in `iptables` IPs that have more than 100 requests.
