local dict = require 'lulz.collections.dict'
local list = require 'lulz.collections.list'

local types = require 'lulz.types'
local utils = require 'lulz.private.utils'
local iterator = require 'lulz.iterator'

local clone = utils.clone


local ordereddict = dict:inherit {
  __name__ = 'ordereddict',

  __init__ = function(self, values)
    rawset(self, '_keys', {})
    dict.__init__(self, values)
  end
}


function ordereddict:__class_call__(data)
  assert(self == ordereddict)
  local inst = ordereddict:new()
  inst._values = data
  for key in dict.keys(data) do
    list.append(inst._keys, key)
  end
  return inst
end


function ordereddict:equals(other)
  if not types.isinstance(other, ordereddict) then return false end
  if self:size() ~= other:size() then return false end

end


function ordereddict:extend(overrides)
  for k,value in iterator(overrides) do
    self[k] = value
  end
end

function ordereddict:clear()
  self._values = {}
  self._keys = {}
end

function ordereddict:size()
  return #self._keys
end

function ordereddict:copy()
  return ordereddict:new(self)
end

function ordereddict:clone()
  return ordereddict:new(self:map(function(k, v) return clone(k), clone(v) end))
end


function ordereddict:insert(key, value)
  if self._values[key] ~= nil then
    return  --- @todo: error? change value?
  end
  dict.insert(self, key, value)
  list.append(self._keys, key)
end

function ordereddict:get(key, default)
  if self._values[key] ~= nil then
    return self._values[key]
  end
  if types.isinstance(key, types.int) then
      return self:get(self._keys[key], default)
  end
  return default
end

function ordereddict:pop(key, default)
  local value = dict.pop(self, key)
  if value == nil then
    return default
  end

  list.remove(self._keys, key)
  return value
end

--[[ Iterators ]]
function ordereddict:iter()
  return self:keys():map(function(k) return k, self._values[k] end)
end

function ordereddict:values()
  return iterator.values(self:iter())
end

function ordereddict:keys()
  return iterator.values(self._keys)
end

return ordereddict
