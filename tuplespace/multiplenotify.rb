# From The dRuby Book by Masatoshi Seki, p. 143
# See <http://www.druby.org/sidruby/code/multiplenotify.rb>

require 'drb/drb'
require 'rinda/rinda'
require 'rinda/tuplespace'

class MultipleNotify
  def initialize(ts, event, ary)
    @queue = Queue.new
    @entry = []
    ary.each do |pattern|
      make_listener(ts, event, pattern)
    end
  end

  def pop
    @queue.pop
  end

  def make_listener(ts, event, pattern)
    entry = ts.notify(event, pattern)
    @entry.push(entry)
    Thread.new do
      entry.each do |ev|
        @queue.push(ev)
      end
    end
  end
end
