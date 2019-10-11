#!/usr/bin/env python3

import zmq
from const import *
context = zmq.Context()

p1 = f"tcp://{HOST}:{PORT1}"        # how and where to connect
p2 = f"tcp://{HOST}:{PORT2}"        # how and where to connect
s  = context.socket(zmq.REP)        # create reply socket

s.bind(p1)                          # bind socket to address
s.bind(p2)                          # bind socket to address
while True:
  message = s.recv_string()         # wait for incoming message
  if not "STOP" in message:         # if not to stop...
    s.send_string(message + "*")    # append "*" to message
  else:                             # else...
    break                           # break out of loop and end
