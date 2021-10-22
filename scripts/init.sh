#!/bin/sh
trap 'jobs -p | xargs kill' EXIT

# bspdir=$(dirname $(readlink -f "$0"))
# cd "$bspdir" || exit &


# Avoid launching a command if it's already running (e.g. when restarting the
# window manager).
is_running() {
    pgrep --full "^$1" > /dev/null
}

~/.fehbg &

is_running 'picom'     || picom -b --experimental-backends &
is_running 'dunst'     || dunst &
is_running 'redshift'  || redshift &

xsetroot -cursor_name left_ptr &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
gnome-keyring-daemon --start --components=pkcs11 &

case $HOSTNAME in
    (pc) \
      xset dpms 600 900 0 &
      xinput --set-prop 14 "libinput Accel Speed" -0.85 &
      xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Button Scrolling Button' 12 &
      xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" 'libinput Scroll Method Enabled' 0 0 1 &
      xset m 1/2 0 &
      xset r rate 350 60 &
      killall -q imwheel
      imwheel &
        ;;
    (x1) \
      xinput set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Speed" 1 &
      xinput set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Profile Enabled" 0, 1 &
      setxkbmap -option ctrl:nocaps &
        ;;
esac

# hide mouse on writting
if $(hash unclutter); then
    unclutter -idle 1 &
fi

cd "$HOME" &&

rclone mount --daemon drive: /home/blinnnk/gdrive/ &
rclone mount --daemon --drive-shared-with-me drive-theia: /home/blinnnk/gdrive-theia/ &
rclone mount --daemon dropbox: /home/blinnnk/dropbox/ &

wait
