local types = require 'lulz.types'
local class = require 'lulz.types.class'
local iterator = require 'lulz.iterator'
local iterable = require 'lulz.iterable'
local fn = require 'lulz.functional'

local utils = require 'lulz.private.utils'


local dict = class {
  __name__  = 'dict',
  __mixin__ = { iterable },

  __init__ = function(self, values)
    rawset(self, '_values', {})
    self:extend(values)
  end,

  __get = function(self, k)
    return self:get(k)
  end,
  __set = function(self, k, v)
    self:insert(k, v)
  end,

  __eq = function(self, other)
    return self:equals(other)
  end
}


function dict:__class_call__(data)
  assert(self == dict)
  local inst = dict:new()
  inst._values = data
  return inst
end


--[[ Utils ]]
local function _dict_data(tbl)
  if types.isinstance(tbl, dict) then
    return tbl._values
  end
  return tbl
end


function dict.equals(a, b, settings)
  return utils.equals(_dict_data(a), _dict_data(b), settings)
end

function dict.dump(a)
  return utils.dump(_dict_data(a))
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

function dict.clone(tbl)
  if types.isinstance(tbl, dict) then
    return dict(utils.clone(_dict_data(tbl)))
  end
  return utils.clone(tbl)
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

function dict.override(tbl, overrides)
  return utils.override(_dict_data(tbl), _dict_data(overrides))
end

function dict.clear(tbl)
  assert(types.isinstance(tbl, dict))
  tbl._values = {}
end

function dict.size(tbl)
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
function dict.iter(tbl)
  return iterator.pairs(_dict_data(tbl))
end

function dict.values(tbl)
  return iterator.values(dict.iter(tbl))
end

function dict.keys(tbl)
  return fn.map(function(k,_) return k end, dict.iter(tbl))
end

return dict