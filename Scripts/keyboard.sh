#!/bin/bash

LAPTOP=`xinput list --id-only "keyboard:AT Translated Set 2 keyboard"`

if EXTERNAL=$(xinput list --id-only "keyboard:Lenovo ThinkPad Compact USB Keyboard with TrackPoint"); then
    echo "External found, setting value"
    setxkbmap -layout dvorak -option caps:escape -device $EXTERNAL
fi

echo 'test'
setxkbmap -layout dvorak -device $LAPTOP
xkbcomp ~/.xkb -i $LAPTOP $DISPLAY



