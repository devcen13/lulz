local types = require 'lulz.types'
local class = require 'lulz.class'
local iterator = require 'lulz.iterator'
local iterable = require 'lulz.iterable'
local fn = require 'lulz.functional'
local utils = require 'lulz.utils'
local str = require 'lulz.str'


local set = class {
  __name__ = 'set',
  __mixin__ = { iterable },

  __init__ = function(self, values)
    rawset(self, '_values', {})
    rawset(self, '_size', 0)
    for elem in iterator.values(values) do
      self:add(elem)
    end
  end,

  count = function(self) return self._size end,
  __len = function(self) return self._size end,

  __get = function(self, k)
    return self._values[k]
  end,
  __set = utils.deleted('Set set is disabled. Use add instead.'),

  __tostring = function(self)
    return 'set { ' .. str.join(', ', self:iter()) .. ' }'
  end,
}
set.__class_call__ = set.new


function set:iter()
  return fn.map(function(k,_) return k end, iterator.pairs(self._values))
end


--[[ Checkers ]]
function set:isdisjoint(other)
  if not types.isinstance(other, set) then return false end
  return self:none(function(elem) return other[elem] end)
end

function set:__eq(other)
  if not types.isinstance(other, set) then return false end
  if self._size ~= other._size then return false end
  return self:all(function(elem) return other[elem] end)
end

function set:__lt(other)
  if not types.isinstance(other, set) then return false end
  if self._size >= other._size then return false end
  return self:all(function(elem) return other[elem] end)
end

function set:__le(other)
  if not types.isinstance(other, set) then return false end
  if self._size > other._size then return false end
  return self:all(function(elem) return other[elem] end)
end

function set:issubset(other)
  return self <= other
end

function set:issuperset(other)
  return self >= other
end

function set:contains(elem)
  return self._values[elem] ~= nil
end

--[[ Modifiers ]]
function set:add(elem)
  if not self._values[elem] then
    self._size = self._size + 1
  end
  self._values[elem] = true
end

function set:remove(elem)
  if self._values[elem] then
    self._size = self._size - 1
  end
  self._values[elem] = nil
end

function set:update(...)
  for v in iterator.values(iterator.concat(...)) do
    self:add(v)
  end
end

function set:intersection_update(...)
  for elem in self:iter() do
    local others = iterator.values({...})
    if not others:all(function(s) return s:contains(elem) end) then
      self:remove(elem)
    end
  end
end

function set:difference_update(...)
  for elem in self:iter() do
    local others = iterator.values({...})
    if others:any(function(s) return s:contains(elem) end) then
      self:remove(elem)
    end
  end
end

function set:symmetric_difference_update(...)
  for elem in self:union(...):iter() do
    local sets = iterator.values({self, ...})
    if sets:count(function(s) return s:contains(elem) end) == 1 then
      self:add(elem)
    else
      self:remove(elem)
    end
  end
end


--[[ Building new ]]
function set:union(...)
  local s = set()
  s:update(self)
  s:update(...)
  return s
end

function set:__add(other)
  return self:union(other)
end

function set:intersection(...)
  local s = set()
  s:update(self)
  s:intersection_update(...)
  return s
end

function set:__mul(other)
  return self:intersection(other)
end

function set:difference(...)
  local s = set()
  s:update(self)
  s:difference_update(...)
  return s
end

function set:__sub(other)
  return self:difference(other)
end

function set:symmetric_difference(...)
  local s = set()
  s:update(self)
  s:symmetric_difference_update(...)
  return s
end

function set:__pow(other)
  return self:symmetric_difference(other)
end

return set
