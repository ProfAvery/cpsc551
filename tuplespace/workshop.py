#!/usr/bin/env python3

import code

import proxy
import config

config = config.read_config()

ts_name      = config['name']
adapter_host = config['adapter']['host']
adapter_port = config['adapter']['port']

adapter_uri = f'http://{adapter_host}:{adapter_port}'

ts = proxy.TupleSpaceAdapter(adapter_uri)

print(f'Connected to tuplespace {ts_name} on {adapter_uri}')

code.interact(local=locals())
