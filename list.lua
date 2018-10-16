local class = require 'lulz.class'
local iterable = require 'lulz.iterable'
local iterator = require 'lulz.iterator'
local dict = require 'lulz.dict'
local str = require 'lulz.str'


local list_config = {
  strict = false
}

local function _validate_index(tbl, i)
  if type(i) ~= 'number' then error('list index is not a number') end
  if i <= 0 or i > #tbl then error('list index out of range') end
end


local list = class 'list' {
  __mixin__ = { iterable },

  __init__ = function(self, data)
    rawset(self, '_values', {})
    self:extend(data)
  end,

  __tostring = function(self)
    return 'list { ' .. str.join(', ', self._values) .. ' }'
  end,

  __len = function(self) return #self._values end,
  size = class.property {
    get = function(self) return #self._values end,
  },

  __get = function(self, k)
    if list_config.strict then _validate_index(self._values, k) end
    return self._values[k]
  end,
  __set = function(self, k, v)
    if list_config.strict then _validate_index(self._values, k) end
    self._values[k] = v
  end
}

function list.configure(cfg)
  dict.extend(list_config, cfg)
end

function list:__class_call__(data)
  assert(self == list)
  local lst = list:new()
  lst._values = data
  return lst
end

--[[ Utils ]]
local function _list_data(tbl)
  if class.is_instance(tbl, list) then
    return tbl._values
  end
  return tbl
end

function list.is_empty(tbl)
  return next(_list_data(tbl)) == nil
end


--[[ Iterators ]]
function list.iter(tbl)
  return iterator.ipairs(_list_data(tbl))
end

function list.items(tbl)
  return iterator.values(list.iter(tbl))
end

--[[ Modifiers ]]
function list.append(tbl, value)
  table.insert(_list_data(tbl), value)
end

function list.extend(tbl, iter)
  local data = _list_data(tbl)
  for value in iterator.values(iter) do
    table.insert(data, value)
  end
end

function list.resize(tbl, size, value)
  local data = _list_data(tbl)
  while #data > size do table.remove(data) end
  while #data < size do table.insert(data, value) end
end

return list
