import re
import typing
import xmlrpc.client

# Credit to Yu Kou (<yuki.coco@csu.fullerton.edu>)
# for making this suggestion and working on type mappings.

class TupleSpaceAdapter:
    PYTHON_TO_RUBY = {
        'str': 'String',
        'int': 'Numeric',
        'float': 'Numeric'
    }

    RANGE_TYPE = type(range(0))

    def __init__(self, uri):
        self.uri = uri
        self.ts = xmlrpc.client.ServerProxy(self.uri, allow_none=True)

    def map_template_out(self, item):
        if isinstance(item, typing.Type):
            python_type = item.__name__
            ruby_type = self.PYTHON_TO_RUBY[python_type]
            if ruby_type is not None:
                return { 'class': ruby_type }
        elif isinstance(item, typing.Pattern):
            return { 'regexp': item.pattern }
        elif isinstance(item, self.RANGE_TYPE):
            return { 'from': item.start, 'to': item.stop - 1 }
        return item

    def map_templates_out(self, tupl):
        return [self.map_template_out(item) for item in tupl]

    def _in(self, tupl):
        return self.ts._in(self.map_templates_out(tupl), None)

    def _inp(self, tupl):
        return self.ts._in(self.map_templates_out(tupl), 0)

    def _rd(self, tupl):
        return self.ts._rd(self.map_templates_out(tupl), None)

    def _rdp(self, tupl):
        return self.ts._rd(self.map_templates_out(tupl), 0)

    def _out(self, tupl):
        self.ts._out(tupl)
