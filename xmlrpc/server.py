#!/usr/bin/env python3

from xmlrpc.server import SimpleXMLRPCServer

server = SimpleXMLRPCServer(("localhost", 8000))

def add(x, y):
    return x + y

def subtract(x, y):
    return x - y

def multiply(x, y):
    return x * y

def divide(x, y):
    return x // y

server.register_function(add, 'add')
server.register_function(subtract, 'subtract')
server.register_function(multiply, 'multiply')
server.register_function(divide, 'divide')

server.serve_forever()
