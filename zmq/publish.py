#!/usr/bin/env python3

import zmq, time
from const import *

context = zmq.Context()
s = context.socket(zmq.PUB)                 # create a publisher socket
p = f"tcp://{HOST}:{PORT}"                  # how and where to communicate
s.bind(p)                                   # bind socket to the address
while True:
  time.sleep(5)                             # wait every 5 seconds
  s.send_string("TIME " + time.asctime())   # publish the current time
