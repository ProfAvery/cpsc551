#!/usr/bin/env ruby

require 'ffi-rzmq'
require './const'

context = ZMQ::Context.new
s = context.socket(ZMQ::SUB)                # create a subscriber socket
p = "tcp://#{HOST}:#{PORT}"                 # how and where to communicate
s.connect(p)                                # connect to the server
s.setsockopt(ZMQ::SUBSCRIBE, "TIME")        # subscribe to TIME messages

5.times do                  # Five iterations
  time = ""
  s.recv_string(time)       # receive a message
  puts(time)
end
