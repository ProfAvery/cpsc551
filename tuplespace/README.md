# Rinda Tuplespace
## with XML-RPC Adapter and Python Proxy

### Tuplespace

 * `tuplespace.rb`
 
Implements a Rinda tuplespace that sends change notifications via IP multicast.

By default, configuration comes from `tuplespace.yaml`. A different
configuration file can be specified with the `-c` or `--config` switch:

    $ ./tuplespace.rb -c config.yaml

Notifications are published in the format "*name* *event* *payload*".

Field     | Description
--------- | --------------------------------------------------------
*name*    | the name of the tuplespace (see `tuplespace.yaml` below)
*event*   | one of `start`, `write`, or `take`
*payload* | `druby://` URI or contents of a tuple marshaled as JSON

 * `tuplespace.yaml`

Configuration file for the tuplespace. 

Setting   | Description
--------- | -----------------------------------------------------------------------
`name`    | Name of the tuplespace. Used in notifications
`uri`     | DRuby URI for tuplespace
`notify`  | List of multicast `host` and `port` values for publishing notifications
`filters` | Tuple patterns which will cause notifications to be sent
`adapter` | `host`, `port`, and `max_clients` for XML-RPC adapter

Filter patterns correspond to Rinda templates. `~` is the YAML syntax
for Ruby's `nil`, so the default filters will cause notifications to be
sent for any tuple of length 2-5.

#### `read_config` function

 * `config.rb`
 * `config.py`

Reads a YAML configuration file and returns a `config` object.

The Python version requires [PyYAML](https://pyyaml.org), which should
already be installed on Tuffix.

If this library is not installed, use one of the following commands:

    $ sudo apt install --yes python3-yaml

or

    $ pip3 install --user PyYAML

#### Support libraries

 * `suppress_warnings.rb`

Temporarily suppresses warnings from the Ruby interpreter.

 * `multiplenotify.rb`

Combines events from multiple Rinda notification requests.

### XML-RPC Adapter

 * `adapter.rb`

XML-RPC adapter for Rinda tuplespaces. Exposes Rinda `take`, `read`,
and `write` operations as `in`, `_rd`, and `_out`.

Handlers for `_in` and `_rd` take an additional parameter in order to
specify timeouts (see *Python Proxy* below).

#### Optional Foreman support

 * `Procfile`

For convenience a tuplespace and accompanying adapter can be started with
[Foreman](https://ddollar.github.io/foreman/).

Use the following command to install foreman:

    $ sudo apt install --yes ruby-foreman

And the following command to start the processes listed in `Procfile`.

    $ foreman start

### Python Proxy

 * `proxy.py`

Defines a `TupleSpaceAdapter` proxy class.

#### Transparent marshaling

This client transparently marshals Python regular expressions, ranges,
and types `str`, `int`, and `float` for XML-RPC so that you can run

    t1 = blog._rd(("bob", "distsys", str))

instead of

    t1 = blog._rd(['bob', ‘distsys', { 'class': 'String' }])

See *Sample code* below for addtional examples.

#### Non-blocking calls

In addition to `_in()`, `_out()`, and `_rd()`, this client defines
non-blocking methods `_inp()` and `_rdp()`.

#### Test clients

 * `workshop.rb`
 * `workshop.py`

Interactive clients for testing tuplespace operations.

Reads a tuplespace configuration YAML file, creates a proxy named `ts`,
then starts an interactive interpreter prompt.

#### Sample code

 * `arithmetic_client.py`
 * `arithmetic_server.py`

Python equivalents of the example programs from
[Wikipedia](https://en.wikipedia.org/wiki/Rinda_(Ruby_programming_language)).

### Multicast client

 * `subscribe.py`

Listens on a given multicast address and port and decodes received
packets as Python strings.
