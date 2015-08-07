#!/bin/bash

echo $(id -un)
[ $(id -un) != 'liz' ] && exec su -c $0 liz

export DISPLAY=:0

LAPTOP=`xinput list --id-only "keyboard:AT Translated Set 2 keyboard"`

if EXTERNAL=$(xinput list --id-only "keyboard:Lenovo ThinkPad Compact USB Keyboard with TrackPoint"); then
    echo "External found, setting value"
    setxkbmap -layout dvorak -option caps:escape -device $EXTERNAL -display $DISPLAY
fi


if YUBIKEY=$(xinput list --id-only "Yubico Yubico Yubikey II"); then
echo 'setting default keymap for yubikey'
    setxkbmap -layout us -option caps:escape -device $YUBIKEY -display $DISPLAY
fi

echo 'Setting up laptop keyboard'
setxkbmap -layout dvorak -device $LAPTOP -display $DISPLAY
xkbcomp /home/liz/.xkb -i $LAPTOP $DISPLAY
