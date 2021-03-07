TERM=xterm-256color # this is likely used in .bashrc somewhere. throws a login error is not set

# Run alaises from .bashrc
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
#         . "$HOME/.bashrc"
#     fi
# fi

if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

{% if ansible_system == "Linux" %}

#xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
#xinput set-button-map 13 1 2 3
#synclient TapButton1=1 TapButton2=3 TapButton3=2


#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode eDP-1 1920x1080_60.00
#xrandr -s 1920x1080

#xinput set-button-map 10 3 2 1

#xrandr --output VGA-0 --primary --mode 1920x1080 --pos 1080x464 --rotate normal --output DVI-0 --mode 1920x1080 --pos 0x0 --rotate left --output HDMI-0 --off

pgrep xautolock > /dev/null || xautolock -detectsleep -time 10 -locker "sh ~/.config/pixel-lock/lock.sh" &

#Always have numlock on
numlockx on

# Sets a random background from this dir
#feh --bg-fill --randomize ~/.config/wallpaper/*.*

# compton -b --paint-on-overlay

# MPD daemon start (if no other user instance exists)
#[ ! -s ~/.config/mpd/pid ] && mpd

# set screen always on
xset -dpms
#xset s noblank
xset s off

xset r on

# faster keyboard repeat
xset r rate 300 40

# https://tylercipriani.com/blog/2015/01/23/toward-a-useful-keyboard-in-x/
#default keyboard layout
#
# Type common accented chars with right alt + letter, e.g. "é" == [Right Alt] + [e]
#setxkbmap -model pc105 -layout gb -variant altgr-intl

#setxkbmap -layout gb -option caps:backspace

# use custom key map
#xmodmap ~/.Xmodmap

# hide idle mouse
#unclutter -idle 10 &

#redshift-gtk &
#

# TODO hack to stop usb mouse suspending
#echo 2 | sudo tee /sys/bus/usb/devices/*/power/autosuspend >/dev/null
#echo on | sudo tee /sys/bus/usb/devices/*/power/level >/dev/null
