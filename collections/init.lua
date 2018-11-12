local collections = {}


collections.list = require 'lulz.collections.list'
collections.dict = require 'lulz.collections.dict'
collections.set  = require 'lulz.collections.set'
collections.stack = require 'lulz.collections.stack'
collections.queue = require 'lulz.collections.queue'
collections.namedtuple = require 'lulz.collections.namedtuple'
collections.ordereddict = require 'lulz.collections.ordereddict'


return collections
