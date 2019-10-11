#!/usr/bin/env python3

import zmq
from const import *
context = zmq.Context()

p1 = f"tcp://{HOST}:{PORT1}"    # how and where to connect
s  = context.socket(zmq.REQ)    # create request socket

s.connect(p1)                   # block until connected
s.send_string("Hello world 1")  # send message
message = s.recv()              # block until response
s.send_string("STOP")           # tell server to stop
print(message.decode())         # print result
