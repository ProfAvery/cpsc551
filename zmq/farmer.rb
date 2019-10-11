#!/usr/bin/env ruby

require 'ffi-rzmq'
require './const'

context = ZMQ::Context.new
me  = ARGV[0]
s   = context.socket(ZMQ::PUSH)         	# create a push socket
src = (me == '1')? SRC1  : SRC2         	# check task source host
prt = (me == '1')? PORT1 : PORT2        	# check task source port
p   = "tcp://#{src}:#{prt}"             	# how and where to connect
s.bind(p)                               	# bind socket to address

100.times do                            	# generate 100 workloads
  workload = rand(1..100)                     	# compute workload
  s.send_string(Marshal.dump([me,workload]))	# send workload to worker
end

