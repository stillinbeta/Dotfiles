#!/usr/bin/env python2
""" Connects to Wicd over Dbus to discover connection status.
Returns exit codes -
0 for connected
1 for connecting
2 for disconnected """
import dbus

bus = dbus.SystemBus()
daemon = dbus.Interface(bus.get_object('org.wicd.daemon', '/org/wicd/daemon'),
                        'org.wicd.daemon')

info = daemon.GetConnectionStatus()
if not (len(info) > 1 and len(info[1]) and info[1][0]):
    exit(2)  # Disconnected
if info[1][0] in ('wired', 'wireless'):
    exit(1)  # Connecting
exit(0)  # Connected
