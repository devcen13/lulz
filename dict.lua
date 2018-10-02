local class = require 'lulz.class'
local iterator = require 'lulz.iterator'
local iterable = require 'lulz.iterable'
local fn = require 'lulz.functional'

local _dict = require 'lulz.private.dict'


local dict = class 'dict' {
  __mixin__ = { iterable },

  override        = _dict.override,
  add_keys        = _dict.add_keys,
  clone_new_items = _dict.clone_new_items,

  __init__ = function(self, values)
    self._values = _dict.clone(values)
  end,
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
  return _dict.equals(_dict_data(a), _dict_data(b), settings)
end

function dict.dump(a)
  return _dict.dump(_dict_data(a))
end

function dict.clone(tbl)
  if class.is_instance(tbl, dict) then
    return dict(_dict.clone(_dict_data(tbl)))
  end
  return _dict.clone(tbl)
end

function dict.extend(tbl, overrides, policy)
  return _dict.extend(_dict_data(tbl), _dict_data(overrides), policy)
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