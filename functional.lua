local utils = require 'lulz.utils'
local class = require 'lulz.class'
local op = require 'lulz.operators'

local not_implemented = utils.not_implemented

local function _id(x)
  return x
end

local function _map(func, params)
  local result = {}
  for k,v in pairs(params) do
    result[k] = func(v)
  end
  return result
end

local function _filter(func, params)
  local result = {}
  for _,v in ipairs(params) do
    if func(v) then table.insert(result, v) end
  end
  return result
end

local function _foldl(func, list, accum)
  if type(func) == 'string' then func = op[func] end
  for _,v in ipairs(list) do
    accum = accum == nil and v or func(accum, v)
  end
  return accum
end


local binder = class {
  __init__ = function(self, func, ...)
    self._func = func
    self._params = { ... }
  end,
  __call__ = function(self, ...)
    return self._func(self:_build_params(...))
  end
}

function binder:_build_params(...)
  if #self._params == 0 then
    return ...
  end
  return unpack(self._params), ...
end


local functional = {
  id = _id,
  map = _map,
  filter = _filter,
  foldl = _foldl,
  foldr = not_implemented,
  bind = function(func, ...) return binder:new(func, ...) end,
}

return functional
