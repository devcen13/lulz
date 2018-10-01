local class = require 'lulz.class'
local iterator = require 'lulz.private.iterator'

local co_create, co_resume, co_yield = coroutine.create, coroutine.resume, coroutine.yield


local generator = iterator:inherit 'generator' {
  __init__ = function(self, ...)
    self._co = co_create(self.gen)
    self._args = {...}
  end,
  next = function(self)
    self._args = { co_resume(self._co, self, unpack(self._args)) }
    if not self._args[1] then return nil end
    return self._args[2], self._args[3]
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
