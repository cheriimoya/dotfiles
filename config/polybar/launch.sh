#!/usr/bin/env bash

# Terminate already running bar instances
for pid in $(pgrep polybar); do
    kill $pid
done

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar default &

echo "Bars launched..."
