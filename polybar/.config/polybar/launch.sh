#!/usr/bin/env sh
#Polybar launcher
#By: agung p (github.com/agp-id)
#Date: 13-02-2022

# Network Interface
defnet=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

# Primary monitor
priMon=$(xrandr --query |grep -w "connected primary" |cut -d" " -f1)

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

## Top bar-------------------------------------------------------------------------------
#if type "xrandr" > /dev/null; then
#    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#        MONITOR=$m _net=$defnet polybar --reload bar1 -c ~/.config/polybar/config.ini &
#    done
#else
    MONITOR=$priMon _net=$defnet polybar --reload bar1 -c ~/.config/polybar/config.ini &
#fi

# Get pid first bar
echo $! > /tmp/polybar_pid1

## Second (bottom) bar---------------------------------------------------------------------------
#if type "xrandr" > /dev/null; then
#    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#         MONITOR=$m polybar --reload bar2 -c ~/.config/polybar/config.ini &
#    done
#else
#    polybar --reload bar2 -c ~/.config/polybar/config.ini &
#fi

## Get pid second bar
#echo $! > /tmp/polybar_pid2

##Polybar toggle------------------------------------------------------
bspc config -m $priMon top_padding > /tmp/top_padding
bspc config -m $priMon bottom_padding > /tmp/bottom_padding
