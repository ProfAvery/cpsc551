#!/usr/bin/env python3

import proxy

ts = proxy.TupleSpaceAdapter('http://localhost:8000')

tuples = [["*", 2, 2 ], [ "+", 2, 5 ], [ "-", 9, 3 ]]

for t in tuples:
    ts._out(t)
    res = ts._in(["result", None])
    print(f"{res[1]} = {t[1]} {t[0]} {t[2]}")
