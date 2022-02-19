#!/usr/bin/env sh

echo "applying hdmi-1-large"

# xrandr --newmode "5120x1440_45.00"  457.00  5120 5448 5992 6864  1440 1443 1453 1480 -hsync +vsync
# xrandr --addmode HDMI-1 "5120x1440_45.00"
# xrandr --output HDMI-1 --mode "5120x1440_45.00"
xrandr --output DisplayPort-0 --mode 5120x1440
