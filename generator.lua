local class = require 'lulz.class'
local iterator = require 'lulz.private.iterator'

local co_wrap, co_yield = coroutine.wrap, coroutine.yield


local generator = iterator:inherit {
  __name__ = 'generator',

  __init__ = function(self, ...)
    self._co = co_wrap(self.gen)
    self._args = {...}
  end,
  next = function(self)
    self._args = { self._co(self, unpack(self._args)) }
    return unpack(self._args)
  end,
  yield = function(_, ...)
    co_yield(...)
  end,

  gen = class.abstract_method()
}

generator.__class_call__ = function(_, tbl)
  local gen = generator:inherit(tbl)
  gen.__class_call__ = gen.new
  return gen
end

return generator
