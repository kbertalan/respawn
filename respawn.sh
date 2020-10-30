#!/usr/sbin/env sh

set -x

PID_FILE=${PID_FILE:-respawn.pid}
PIPE_FILE=${PIPE_FILE:-respawn.pipe}

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
  fi
fi

if [ ! -e "$PIPE_FILE" ]; then
  mkfifo "$PIPE_FILE"
fi

"$@" > "$PIPE_FILE" &
echo $! > "$PID_FILE"

