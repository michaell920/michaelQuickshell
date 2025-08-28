#!/usr/bin/env python

# A simple script to monitor wayfire window title

from wayfire import WayfireSocket
import json

sock = WayfireSocket()
sock.watch()

while True:
    msg = sock.read_next_event()
    if "event" in msg:
        if "view" in msg:
            if (msg["view"] is not None and msg["view"]["title"] is not "layer-shell"):
                print(json.dumps(msg["view"]), flush=True)
            else:
                print("", flush=True)
