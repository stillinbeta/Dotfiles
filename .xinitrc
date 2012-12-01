#!/bin/sh

#disable the touchpad
xinput --set-prop "SynPS/2 Synaptics TouchPad" "Device Enabled" 0

#Set up the pointer for scrolling
. ~/.xinit-trackpoint

setxkbmap dvorak

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
~/.dropbox-dist/dropboxd &
xbindkeys &
sudo xfce4-power-manager &

#Launch Awesome
exec awesome
#~/.xmonad/xmonad-x86_64-linux
