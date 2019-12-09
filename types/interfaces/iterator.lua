local interface = require 'lulz.types.interface'

local iterator = interface:new {
  __name__ = 'iterator';
  next = interface.impl_required;
  __call = function(self, ...)
    return self:next(...)
  end
}


return iterator
