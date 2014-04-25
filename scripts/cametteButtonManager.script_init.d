#!/bin/bash
### BEGIN INIT INFO
# Provides:          cametteButtonManager
# Required-Start:    $syslog
# Should-Start:      cametteButtonManager
# Required-Stop:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 6
# Short-Description: Camette button manager daemon
### END INIT INFO

DAEMON=/usr/bin/cametteButtonManager
NAME=cametteButtonManager
DESC="Camette button manager daemon"
CHUID="root"
PIDFILE=/var/run/camettebuttonmng.pid

if ! [ -x "/lib/lsb/init-functions" ]; then
  . /lib/lsb/init-functions
else
  echo "E: /lib/lsb/init-functions not found, lsb-base (>= 3.0-6) needed"
  exit 1
fi

case "$1" in
  start)
        log_daemon_msg "Starting $DESC" "$NAME"
        start-stop-daemon --start --quiet \
                --pidfile $PIDFILE \
                --chuid $CHUID \
                --exec $DAEMON || log_end_msg 1 &
        log_end_msg 0
        ;;
  stop)
	kill -9 $(ps aux |grep "/bin/bash /usr/bin/cametteButtonManager" | awk '{print $2}' |head -1)
        log_daemon_msg "Stopping $DESC" "$NAME"
        start-stop-daemon --stop --quiet --retry 15 --oknodo \
                --pidfile $PIDFILE \
                --exec $DAEMON || log_end_msg 1
        log_end_msg 0i

	echo "27" > /sys/class/gpio/unexport
	echo "4" > /sys/class/gpio/unexport
	echo "17" > /sys/class/gpio/unexport
	echo "22" > /sys/class/gpio/unexport

        ;;
  restart|force-reload)
        #
        #       If the "reload" option is implemented, move the "force-reload"
        #       option to the "reload" entry above. If not, "force-reload" is
        #       just the same as "restart".
        #
        echo -n "Restarting $DESC: "
        kill -9 $(ps aux |grep "/bin/bash /usr/bin/cametteButtonManager" | awk '{print $2}' |head -1)

	log_daemon_msg "Restarting $DESC: "
        start-stop-daemon --stop --quiet --retry 15 --oknodo --pidfile \
                /var/run/$NAME.pid --exec $DAEMON || log_end_msg 1

	echo "27" > /sys/class/gpio/unexport
	echo "4" > /sys/class/gpio/unexport
	echo "17" > /sys/class/gpio/unexport
	echo "22" > /sys/class/gpio/unexport

        start-stop-daemon --start --quiet --pidfile \
                /var/run/$NAME.pid --exec $DAEMON || log_end_msg 1
        log_end_msg 0
        ;;
  *)
        N=/etc/init.d/$NAME
        # echo "Usage: $N {start|stop|restart|force-reload}" >&2
        log_action_msg "Usage: $N {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

