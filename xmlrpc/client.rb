#!/usr/bin/env ruby

require 'xmlrpc/client'

server = XMLRPC::Client.new2('http://localhost:8000/RPC2')
proxy = server.proxy

puts "7+3=#{proxy.add(7, 3)}"
puts "7-3=#{proxy.subtract(7, 3)}"
puts "7*3=#{proxy.multiply(7, 3)}"
puts "7/3=#{proxy.divide(7, 3)}"
