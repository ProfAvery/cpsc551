require 'yaml'
require 'optparse'

def read_config
  config_filename = 'tuplespace.yaml'

  ARGV.options do |opts|
    opts.on('-c', '--config=file', String) { |val| config_filename = val }
    opts.parse!
  end

  yaml = IO.read config_filename
  YAML.load(yaml)
end

