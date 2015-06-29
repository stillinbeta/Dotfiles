#!/bin/bash

echo $(id -un)
[ $(id -un) != 'liz' ] && exec su -c $0 liz

export DISPLAY=:0

LAPTOP=`xinput list --id-only "keyboard:AT Translated Set 2 keyboard"`

if EXTERNAL=$(xinput list --id-only "keyboard:Lenovo ThinkPad Compact USB Keyboard with TrackPoint"); then
    echo "External found, setting value"
    setxkbmap -layout dvorak -option caps:escape -device $EXTERNAL -display $DISPLAY
fi

echo 'test'
setxkbmap -layout dvorak -device $LAPTOP -display $DISPLAY
xkbcomp /home/liz/.xkb -i $LAPTOP $DISPLAY
