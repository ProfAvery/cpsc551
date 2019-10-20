#!/usr/bin/env ruby

require 'rinda/rinda'

require './config'

config = read_config

ts_name = config['name']
ts_uri =  config['uri']

DRb.start_service
rinda = DRbObject.new_with_uri ts_uri
ts = Rinda::TupleSpaceProxy.new rinda

puts "Connected to tuplespace #{ts_name} on #{ts_uri}"

binding.irb
