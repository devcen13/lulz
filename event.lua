local class = require 'lulz.class'
local fn = require 'lulz.functional'
local list = require 'lulz.collections.list'


local delegate = class {
  __name__ = 'delegate',
  __init__ = function(self, arg1, arg2)
    self._callable = arg2 == nil and arg1 or fn.bind(arg2, arg1)
  end,

  __call = function(self, ...)
    self._callable(...)
  end,

  __eq = function(self, other)
    return self._callable == other._callable
  end
}

delegate.__class_call__ = delegate.new


local event = class {
  __name__ = 'event',
  __init__ = function(self)
    self._subscribers = list:new()
  end
}

event.__class_call__ = event.new


function event:subscribe(...)
  self._subscribers:append(delegate(...))
end

function event:unsubscribe(...)
  self._subscribers:remove(delegate(...)) --- @todo list.remove
end

function event:raise(...)
  for handler in self._subscribers:items() do
    handler(...)
  end
end


return event
