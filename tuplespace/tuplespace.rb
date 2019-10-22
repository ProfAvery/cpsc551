#!/usr/bin/env ruby

require 'json'
require 'socket'
require 'rinda/tuplespace'

require './config'
require './multicast'
require './multiplenotify'

def start_tuplespace(name, uri)
  ts = Rinda::TupleSpace.new
  DRb.start_service(uri, ts)
  puts "Tuplespace #{name} started at #{DRb.uri}"
  ts
end

def map_symbols_out(tuple)
  tuple.map do |item|
    (item.is_a? Symbol)? { :symbol => item } : item
  end
end

config = read_config

ts_name = config['name']
ts_uri  = config['uri']

notify_addrs = config['notify']

ts = start_tuplespace ts_name, ts_uri

begin
  sock = open_multicast_socket
  notify_addrs.each do |dest|
    puts "Sending notifications to udp://#{dest['address']}:#{dest['port']}"
  end
  notify_all notify_addrs, sock, "#{ts_name} start #{ts_uri}"

  mn = MultipleNotify.new ts, nil, config['filters']
  loop do
    event, tuple = mn.pop
    json = JSON.generate(map_symbols_out(tuple))
    notify_all notify_addrs, sock, "#{ts_name} #{event} #{json}"
  end

  DRb.thread.join
rescue Interrupt
  puts
ensure
  sock.close
  DRb.stop_service
end
