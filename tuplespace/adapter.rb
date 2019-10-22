#!/usr/bin/env ruby

require 'rinda/rinda'
require 'xmlrpc/server'

require './config'
require './multicast'
require './suppress_warnings'

suppress_warnings do
    XMLRPC::Config::ENABLE_NIL_PARSER = true
    XMLRPC::Config::ENABLE_NIL_CREATE = true
end

def start_tuplespace_proxy(name, uri)
  DRb.start_service
  rinda = DRbObject.new_with_uri uri
  Rinda::TupleSpaceProxy.new rinda
end

def map_templates_in(tuple)
  (map_symbols_in tuple).map do |item|
    unless item.is_a? Hash
      item
    else
      if item.key? 'class'
        Module.const_get item['class']
      elsif item.key? 'regexp'
        Regexp.new item['regexp']
      elsif item.key? 'from' and item.key? 'to'
        Range.new item['from'], item['to']
      else
        raise ArgumentError.new "Unexpected tuple item: #{item.inspect}"
       end
    end
  end
end

def map_symbols_in(tuple)
  tuple.map do |item|
    if item.is_a? Hash and item.key? 'symbol'
      item['symbol'].to_sym
    else
      item
    end
  end
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

adapter_host        = config['adapter']['host']
adapter_port        = config['adapter']['port']
adapter_max_clients = config['adapter']['max_clients']

adapter_uri = "http://#{adapter_host}:#{adapter_port}"

ts = start_tuplespace_proxy ts_name, ts_uri

server = XMLRPC::Server.new(adapter_port, adapter_host, adapter_max_clients)
puts "Adapter for tuplespace #{ts_name} started at #{adapter_uri}"

begin
  sock = open_multicast_socket
  notify_addrs.each do |dest|
    puts "Sending notifications to udp://#{dest['address']}:#{dest['port']}"
  end
  notify_all notify_addrs, sock, "#{ts_name} adapter #{adapter_uri}"
ensure
  sock.close
end

server.add_handler('_in') do |tuple, sec|
  begin
    map_symbols_out(ts.take map_templates_in(tuple), sec)
  rescue Rinda::RequestExpiredError
    nil
  end
end

server.add_handler('_rd') do |tuple, sec|
  begin
    map_symbols_out(ts.read map_templates_in(tuple), sec)
  rescue Rinda::RequestExpiredError
    nil
  end
end

server.add_handler('_out') do |tuple|
    ts.write map_symbols_in(tuple)
    nil
end

server.serve
