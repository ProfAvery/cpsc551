#!/usr/bin/env ruby

require 'ffi-rzmq'
require './const'

context = ZMQ::Context.new
s = context.socket(ZMQ::PUB)                # create a publisher socket
p = "tcp://#{HOST}:#{PORT}"                 # how and where to communicate
s.bind(p)                                   # bind socket to the address
loop do
  sleep(5)                             	    # wait every 5 seconds
  s.send_string("TIME " + Time.now.asctime) # publish the current time
end
