#!/bin/csh
# if the user is a member of the wheel group, add sbin paths to
# his default path
groups | grep -q "^wheel \| wheel \| wheel$"
retval=$?
if ( $retval == 0 ) set path = ( $path /usr/local/sbin /sbin /usr/sbin )
