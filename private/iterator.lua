local class = require 'lulz.class'
local I = require 'lulz.interfaces'

local iterator = class 'iterator' {
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
