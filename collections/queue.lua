local types = require 'lulz.types'
local class = require 'lulz.types.class'
local I = require 'lulz.types.interfaces'
local generator = require 'lulz.generator'
local str = require 'lulz.str'


local queue = class {
  __name__ = 'queue',

  __init__ = function(self)
    rawset(self, '_values', {})
  end,

  __tostring = function(self)
    return 'queue { ' .. str.join(', ', self._values) .. ' }'
  end,

  count = function(self) return #self._values end,
  __len = function(self) return #self._values end,

  empty = function(self) return self:count() == 0 end;

  __get = function() error('Queue get is disabled. Use dequeue instead.') end,
  __set = function() error('Queue set is disabled. Use enqueue instead.') end,
}

queue.__class_call__ = queue.new


--[[ Utils ]]
local function _queue_data(tbl)
  if types.isinstance(tbl, queue) then
    return tbl._values
  end
  return tbl
end

function queue.is_empty(tbl)
  return next(_queue_data(tbl)) == nil
end


--[[ Iterators ]]
local _queue_iter = generator {
  gen = function(self, q)
    q = _queue_data(q)
    while not queue.is_empty(q) do
      self:yield(queue.dequeue(q))
    end
  end
}

I.iterable:impl(queue, {
  iter = function(tbl)
    return _queue_iter(_queue_data(tbl))
  end
})

--[[ Modifiers ]]
function queue.enqueue(tbl, value)
  table.insert(_queue_data(tbl), value)
end

function queue.dequeue(tbl)
  return table.remove(_queue_data(tbl), 1)
end

function queue.next(tbl)
  return _queue_data(tbl)[1]
end

return queue
