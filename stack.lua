local class = require 'lulz.class'
local iterable = require 'lulz.iterable'
local generator = require 'lulz.generator'
local str = require 'lulz.str'
local utils = require 'lulz.utils'


local stack = class 'stack' {
  __mixin__ = { iterable },

  __init__ = function(self)
    rawset(self, '_values', {})
  end,

  __tostring = function(self)
    return 'stack { ' .. str.join(', ', self._values) .. ' }'
  end,

  __len = function(self) return #self._values end,
  size = class.property {
    get = function(self) return #self._values end,
  },

  __get = utils.deleted('Stack get is disabled. Use pop instead.'),
  __set = utils.deleted('Stack set is disabled. Use push instead.'),
}

stack.__class_call__ = stack.new


--[[ Utils ]]
local function _stack_data(tbl)
  if class.is_instance(tbl, stack) then
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

function stack.iter(tbl)
  return _stack_iter(_stack_data(tbl))
end

--[[ Modifiers ]]
function stack.push(tbl, value)
  table.insert(_stack_data(tbl), value)
end

function stack.pop(tbl)
  return table.remove(_stack_data(tbl))
end

function stack.top(tbl)
  return _stack_data(tbl)[#tbl]
end

return stack
