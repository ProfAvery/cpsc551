#!/usr/bin/env ruby

require 'ffi-rzmq'
require './const'
context = ZMQ::Context.new

p1 = "tcp://#{HOST}:#{PORT1}"       # how and where to connect
p2 = "tcp://#{HOST}:#{PORT2}"       # how and where to connect
s  = context.socket(ZMQ::REP)       # create reply socket

s.bind(p1)                          # bind socket to address
s.bind(p2)                          # bind socket to address
loop do
  message = ""
  s.recv_string(message)            # wait for incoming message
  if not message.include? "STOP"    # if not to stop...
    s.send_string(message + "*")    # append "*" to message
  else                              # else...
    break                           # break out of loop and end
  end
end
