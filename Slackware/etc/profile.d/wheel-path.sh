#!/bin/sh
# if the user is a member of the wheel group, add sbin paths to
# his default path
groups | grep -q "^wheel \| wheel \| wheel$"
retval=$?
if [ $retval -eq 0 ]; then
	export PATH=$PATH:/usr/local/sbin:/sbin:/usr/sbin
fi
