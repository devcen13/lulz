local types = require 'lulz.types'
local class = require 'lulz.types.class'
local I = require 'lulz.types.interfaces'
local iterator = require 'lulz.iterator'
local fn = require 'lulz.functional'


local dict = class {
  __name__  = 'dict';

  __init__ = function(self, values)
    rawset(self, '_values', {})
    self:extend(values)
  end;

  __get = function(self, k)
    return self:get(k)
  end;
  __set = function(self, k, v)
    self:insert(k, v)
  end;

  __eq = function(self, other)
    return self:equals(other)
  end;
}


local function _dict_data(tbl)
  if types.isinstance(tbl, dict) then
    return tbl._values
  end
  return tbl
end


I.clonable:impl(dict, {
  clone = function(self)
    return dict(self._values)
  end
})

I.iterable:impl(dict, {
  iter = function(self)
    return iterator.pairs(_dict_data(self))
  end
})

I.equatable:impl(dict, {
  equals = function(self, other)
    return I.equatable.equals(self._values, other._values)
  end
})

I.displayable:impl(dict, {
  dump = function(a)
    return I.displayable.dump(_dict_data(a))
  end
})


function dict:__class_call__(data)
  assert(self == dict)
  local inst = dict:new()
  inst._values = data or {}
  return inst
end


--[[ Utils ]]
function dict:data()
  return self._values
end

function dict.copy(tbl)
  if types.isinstance(tbl, dict) then
    return dict:new(_dict_data(tbl))
  end

  local copy = {}
  for k,v in pairs(tbl) do
    copy[k] = v
  end
  return copy
end

function dict.insert(tbl, key, value)
  _dict_data(tbl)[key] = value
end

function dict.extend(tbl, overrides)
  local data = _dict_data(tbl)
  for k,value in iterator(overrides) do
    data[k] = value
  end
end

function dict.clear(tbl)
  assert(types.isinstance(tbl, dict))
  tbl._values = {}
end

function dict.count(tbl)
  return fn.count(_dict_data(tbl))
end

function dict.is_empty(tbl)
  return next(_dict_data(tbl)) == nil
end

function dict.get(tbl, key, default)
  tbl = _dict_data(tbl)
  local value = tbl[key]
  if value ~= nil then return value end
  return default
end

function dict.pop(tbl, key, default)
  tbl = _dict_data(tbl)
  local value = tbl[key]
  if value ~= nil then
    tbl[key] = nil
    return value
  end
  return default
end


--[[ Iterators ]]

function dict.values(tbl)
  return iterator.values(dict.iter(tbl))
end

function dict.keys(tbl)
  return fn.map(function(k,_) return k end, dict.iter(tbl))
end

return dict