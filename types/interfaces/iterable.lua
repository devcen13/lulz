local interface = require 'lulz.types.interface'

local iterable = interface:new {
  __name__ = 'iterable';
  iter = interface.impl_required
}


return iterable
