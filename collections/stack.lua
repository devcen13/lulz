local types = require 'lulz.types'
local class = require 'lulz.types.class'
local I = require 'lulz.types.interfaces'
local generator = require 'lulz.generator'
local str = require 'lulz.str'


local stack = class {
  __name__ = 'stack',

  __init__ = function(self)
    rawset(self, '_values', {})
  end,

  __tostring = function(self)
    return 'stack { ' .. str.join(', ', self._values) .. ' }'
  end,

  empty = function(self) return self:count() == 0 end;
  count = function(self) return #self._values end,
  __len = function(self) return #self._values end,

  __get = function() error('Stack get is disabled. Use pop instead.') end,
  __set = function() error('Stack set is disabled. Use push instead.') end,
}

stack.__class_call__ = stack.new


--[[ Utils ]]
local function _stack_data(tbl)
  if types.isinstance(tbl, stack) then
    return tbl._values
  end
  return tbl
end

function stack.is_empty(tbl)
  return next(_stack_data(tbl)) == nil
end


--[[ Iterators ]]
local _stack_iter = generator {
  gen = function(self, q)
    while not stack.is_empty(q) do
      self:yield(stack.pop(q))
    end
  end
}

I.iterable:impl(stack, {
  iter = function(tbl)
    return _stack_iter(_stack_data(tbl))
  end
})

--[[ Modifiers ]]
function stack.push(tbl, value)
  table.insert(_stack_data(tbl), value)
end

function stack.pop(tbl)
  return table.remove(_stack_data(tbl))
end

function stack.top(tbl)
  tbl = _stack_data(tbl)
  return tbl[#tbl]
end

return stack
