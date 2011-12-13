#!/bin/sh

#disable the touchpad
xinput --set-prop "SynPS/2 Synaptics TouchPad" "Device Enabled" 0


#setup the pointer for scrolling
xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 8 1
xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 8 2
#xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 8 200
xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 8 6 7 4 5

#load Xresources
#mostly for urxvt
xrdb ~/.Xresources

#xmodmap - for vim
xmodmap ~/.Xmodmap

#setup dbus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

#setup ibus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

#Extra programs
dropboxd &
wicd-client &
xbindkeys &

#Launch Awesome
exec awesome 


