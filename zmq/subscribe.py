#!/usr/bin/env python3

import zmq
from const import *

context = zmq.Context()
s = context.socket(zmq.SUB)                 # create a subscriber socket
p = f"tcp://{HOST}:{PORT}"                  # how and where to communicate
s.connect(p)                                # connect to the server
s.setsockopt_string(zmq.SUBSCRIBE, "TIME")  # subscribe to TIME messages

for i in range(5):          # Five iterations
  time = s.recv_string()    # receive a message
  print(time)
