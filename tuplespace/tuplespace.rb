#!/usr/bin/env ruby

require 'json'
require 'rinda/tuplespace'

require 'ffi-rzmq'

require './config'
require './multiplenotify'

def start_tuplespace(name, uri)
  ts = Rinda::TupleSpace.new
  DRb.start_service(uri, ts)
  puts "Tuplespace #{name} started at #{DRb.uri}"
  ts
end

def open_socket(address)
  ctx = ZMQ::Context.new
  sock = ctx.socket(ZMQ::PUB)
  sock.bind(address)
  puts "Sending notifications to #{address}"
  sock
end

def map_symbols_out(tuple)
  tuple.map do |item|
    (item.is_a? Symbol)? { :symbol => item } : item
  end
end

config = read_config

ts_name = config['name']
ts_uri  = config['uri']

ts = start_tuplespace ts_name, ts_uri
s = open_socket config['notify']

mn = MultipleNotify.new ts, nil, config['filters']
loop do
  event, tuple = mn.pop
  json = JSON.generate(map_symbols_out(tuple))
  notification = "#{ts_name} #{event} #{json}"
  s.send_string notification
  puts notification
end

DRb.thread.join

