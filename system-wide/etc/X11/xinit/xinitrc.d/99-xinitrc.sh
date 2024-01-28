#!/usr/bin/env sh

xtrlock -f &
pipewire &
#xbacklight -set 30% &

## Disable beep & speed xrate up
xset -b r rate 300 50 &

exec dbus-launch bspwm
