#!/usr/sbin/env sh

PID_FILE=${PID_FILE:-respawn.pid}

if [ -z "$*" ]; then
  echo "Command was not specified"
  exit 1
else
  echo "Respawning:" "$@"
fi

if [ -r "$PID_FILE" ]; then
  PID=$(cat $PID_FILE)
  if ps -o cmd fp $PID | grep "$1"; then
    kill -2 $PID
    while [ -e /proc/$PID ]; do sleep 0.1; done
    echo "Killed previous command"
  fi
fi

"$@" &
echo $! > "$PID_FILE"

