#!/usr/bin/env ruby

require 'ffi-rzmq'
require './const'
context = ZMQ::Context.new

p1 = "tcp://#{HOST}:#{PORT1}"   # how and where to connect
s  = context.socket(ZMQ::REQ)   # create request socket

s.connect(p1)                   # block until connected
s.send_string("Hello world 1")  # send message
message = ZMQ::Message.new
s.recvmsg(message)              # block until response
s.send_string("STOP")           # tell server to stop
puts(message.copy_out_string)   # print result
