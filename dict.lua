local class = require 'lulz.class'
local iterator = require 'lulz.iterator'
local iterable = require 'lulz.iterable'
local fn = require 'lulz.functional'

local utils = require 'lulz.private.utils'


local dict = class 'dict' {
  __mixin__ = { iterable },

  size = class.property {
    get = function(self) return fn.count(self._values) end
  },

  __init__ = function(self, values)
    self._values = utils.clone(values)
  end,

  __index__ = function(self, k)
    return self._values[k]
  end,
  __newindex__ = function(self, k, v)
    self._values[k] = v
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
  if class.is_instance(tbl, dict) then
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

function dict.clone(tbl)
  if class.is_instance(tbl, dict) then
    return dict(utils.clone(_dict_data(tbl)))
  end
  return utils.clone(tbl)
end

function dict.extend(tbl, overrides)
  return utils.extend(_dict_data(tbl), _dict_data(overrides))
end

function dict.override(tbl, overrides)
  return utils.override(_dict_data(tbl), _dict_data(overrides))
end


--[[ Iterators ]]
function dict.iter(tbl)
  return iterator.ipairs(_dict_data(tbl))
end

function dict.values(tbl)
  return iterator.values(dict.iter(tbl))
end

function dict.keys(tbl)
  return fn.map(function(k,_) return k end, dict.iter(tbl))
end

return dict