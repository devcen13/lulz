local class = require 'lulz.types.class'
local I = require 'lulz.interfaces'

local iterator = class {
  __name__ = 'iterator',
  __mixin__ = { I.iterable },

  next = class.abstract_method(),

  __call = function(self, ...)
    return self:next(...)
  end,

  iter = function(self)
    return self
  end
}

return iterator
