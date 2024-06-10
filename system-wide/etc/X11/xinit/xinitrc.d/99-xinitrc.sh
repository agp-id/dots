#!/usr/bin/env sh

user="$(who | cut -f 1 -d " ")"
bspwm="/home/$user/.config/bspwm"
polybar="/home/$user/.config/polybar/config.ini"
width=$(xrandr | grep '*' |sed 's/ //g;s/x.*//')
k_led=$(ls /sys/class/leds/ | grep kbd_backlight)

case $width in
    '1920'*)
        top_padding=30;;
    *)
        width=1366
        top_padding=27;;
esac

sed --follow-symlink -i \
    -e "s/top_padding=.*/top_padding=$top_padding/" \
        $bspwm/bspwmrc
sed --follow-symlink -i \
        -e "s/top_padding=.*/top_padding=$top_padding/" \
        $bspwm/external_rules

sed --follow-symlink -i \
        -e "s/^inherit =.*/inherit = $width/g" \
        -e "s/net\..*/net\.$width}/" \
        -e "/\[$width\]/!b;n;cheight = $top_padding" \
        $polybar
xtrlock -f &
pipewire &
#xbacklight -set 30% &
test -n $k_led && brightnessctl --device="$k_led" set 1 &

## Disable beep & speed xrate up
xset -b r rate 300 50 &
exec dbus-launch bspwm
