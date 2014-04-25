#!/bin/bash
### BEGIN INIT INFO
# Provides:          camette_node
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:	     0 1 6
# X-Interactive:     true
# Description: run nodejs for camette use
# Short-Description:    camette nodejs run
### END INIT INFO

case $1 in
        start)
        	/usr/local/bin/node /root/camette.js &>/var/log/camettelog &
	;;
        stop)
	;;
esac
