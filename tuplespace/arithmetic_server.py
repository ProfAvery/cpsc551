#!/usr/bin/env python3

import re

import proxy

ts = proxy.TupleSpaceAdapter('http://localhost:8000')

while True:
    ops, a, b = ts._in([re.compile(r'^[-+/*]$'), int, int])

    if ops == '-':
        result = a - b
    elif ops == '+':
        result = a + b
    elif ops == '/':
        result = a // b
    elif ops == '*':
        result = a * b

    ts._out(['result', result])

