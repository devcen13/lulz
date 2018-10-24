local fn = require 'lulz.functional'
local str = require 'lulz.str'

local namedtuple = {}

local function _disabled(reason)
  return function() error(reason) end
end

local function _tuple_tostring(inst)
  local name = inst.__type__.__name__ or 'tuple'
  local values = str.join(', ', fn.map(function(_,k) return inst[k] end, inst.__type__.__items__))
  return name .. '<' .. values .. '>'
end

local function _construct_namedtuple(tuple, ...)
  local instance = {
    __type__ = tuple
  }
  local args = {...}
  for i,name in ipairs(tuple.__items__) do
    instance[name] = args[i]
  end
  return setmetatable(instance, {
    __index    = _disabled(""),
    __newindex = _disabled(""),
    __tostring = _tuple_tostring
  })
end

local function _build_namedtuple(name, items)
  local tbl = {
    __name__ = name,
    __items__ = items
  }
  return setmetatable(tbl, {
    __index    = _disabled(""),
    __newindex = _disabled(""),
    __call = _construct_namedtuple,
    __tostring = function(tuple) return 'namedtuple ' .. tuple.__name__ end,
  })
end

local function _namedtuple(_, param1, param2)
  if type(param1) == 'string' then
    assert(type(param2) == 'table')
    return _build_namedtuple(param1, param2)
  end
  assert(type(param1) == 'table')
  return _build_namedtuple('namedtuple', param1)
end

return setmetatable(namedtuple, {
  __call = _namedtuple
})
