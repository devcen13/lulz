local class = require 'lulz.class'


local iterator = class 'iterator' {
  next = class.abstract_method(),

  __call__ = function(self, ...)
    return self:next(...)
  end
}


return iterator
