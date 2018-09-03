local class = require 'lulz.class'

local co_create, co_resume = coroutine.create, coroutine.resume


local generator = class 'generator' {
  __init__ = function(self, gen)
    self._gen = gen
  end,
  __call__ = function(self, ...)
    local gen = co_create(self._gen)
    local args = {...}
    return function()
      local _, k, v = co_resume(gen, unpack(args))
      args = {}
      return k, v
    end
  end
}

generator.__class_call__ = generator.new

return generator
