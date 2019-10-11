#!/usr/bin/env ruby

require 'ffi-rzmq'
require './const'

context = ZMQ::Context.new
me = ARGV[0]
r  = context.socket(ZMQ::PULL)  # create a pull socket
p1 = "tcp://#{SRC1}:#{PORT1}"   # address first task source
p2 = "tcp://#{SRC2}:#{PORT2}"   # address second task source
r.connect(p1)                   # connect to task source 1
r.connect(p2)                   # connect to task source 2

puts("#{me} started")

loop do
  msg = ZMQ::Message.new
  r.recvmsg(msg)
  work = Marshal.load(msg.copy_out_string)	# receive work from a source
  puts("#{me} received #{work[1]} from  #{work[0]}")
  sleep(work[1]*0.01) 		     		# pretend to work
end
