#!/usr/bin/env ruby

require 'xmlrpc/server'

server = XMLRPC::Server.new(8000)

server.add_handler 'add' do |x, y|
    x + y
end

server.add_handler 'subtract' do |x, y|
    x - y
end

server.add_handler 'multiply' do |x, y|
    x * y
end

server.add_handler 'divide' do |x, y|
    x / y
end

server.serve
