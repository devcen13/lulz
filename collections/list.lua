local types = require 'lulz.types'
local class = require 'lulz.class'
local iterable = require 'lulz.iterable'
local iterator = require 'lulz.iterator'
local dict = require 'lulz.collections.dict'
local str = require 'lulz.str'
local utils = require 'lulz.private.utils'


local list_config = {
  strict = false
}

local function _validate_index(tbl, i)
  if type(i) ~= 'number' then error('list index is not a number') end
  if i <= 0 or i > #tbl then error('list index out of range') end
end


local list = class {
  __name__ = 'list',
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
  if types.isinstance(tbl, list) then
    return tbl._values
  end
  return tbl
end

function list.is_empty(tbl)
  return next(_list_data(tbl)) == nil
end

function list.__eq(tbl, other)
  return utils.equals(_list_data(tbl), _list_data(other))
end

function list.index(tbl, value)
  local data = _list_data(tbl)
  for i = 1,#data do
    if data[i] == value then
      return i
    end
  end
end


--[[ Iterators ]]
function list.iter(tbl)
  return iterator.ipairs(_list_data(tbl))
end

function list.items(tbl)
  return iterator.values(list.iter(tbl))
end

--[[ Modifiers ]]
function list.insert(tbl, value, index)
  table.insert(_list_data(tbl), value, index)
end

function list.append(tbl, value)
  table.insert(_list_data(tbl), value)
end

function list.extend(tbl, iter)
  local data = _list_data(tbl)
  for value in iterator.values(iter) do
    table.insert(data, value)
  end
end

function list.remove(tbl, value)
  local data = _list_data(tbl)
  for i = 1,#data do
    if data[i] == value then
      table.remove(data, i)
      return true
    end
  end
end

function list.pop(tbl, index)
  return table.remove(_list_data(tbl), index)
end

function list.resize(tbl, size, value)
  local data = _list_data(tbl)
  while #data > size do table.remove(data) end
  while #data < size do table.insert(data, value) end
end


--[[ Algorithms ]]
function list.reverse(tbl)
  local data = _list_data(tbl)
  local len = #data
  for i = 1, math.floor(len/2) do
    local tmp = data[i]
    data[i] = data[len - i + 1]
    data[len - 1 + 1] = tmp
  end
end

function list.sort(tbl, predicate)
  table.sort(_list_data(tbl), predicate)
end

return list
