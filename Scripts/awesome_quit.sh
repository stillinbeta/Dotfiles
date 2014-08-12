#!/bin/sh
zenity --question "quit awesome?" && echo 'awesome.quit()' | awesome-client
