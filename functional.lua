local utils = require 'lulz.utils'
local class = require 'lulz.class'
local op = require 'lulz.operators'
local generator = require 'lulz.generator'

local sign = require('lulz.math').sign

local not_implemented = utils.not_implemented


local function _id(x)
  return x
end

local _range = generator {
  gen = function(self, start, stop, step)
    if stop == nil then
      stop = start
      start = 1
    end
    if step == nil then step = sign(stop - start) end

    local i = start
    local done = function()
      if step < 0 then return i < stop end
      return i > stop
    end
    while not done() do
      self:yield(i)
      i = i + step
    end
  end
}

local function _compose(f, g)
  return function(...) return f(g(...)) end
end

local _map = generator {
  gen = function(func, params)
    for a,b,c,d,e,f in params do
      yield(func(a,b,c,d,e,f))
    end
  end
}

local _filter = generator {
  gen = function(self, func, params)
    for a,b,c,d,e,f in params do
      if func(a,b,c,d,e,f) then
        self:yield(a,b,c,d,e,f)
      end
    end
  end
}

local function _foldl(func, list, accum)
  if type(func) == 'string' then func = op[func] end
  for _,v in ipairs(list) do
    if accum == nil then
      accum = v
    else
      accum = func(accum, v)
    end
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


local _xrepeat = generator {
  gen = function(self, value)
    while true do
      self:yield(value)
    end
  end
}

local _take = generator {
  gen = function(self, count, iter)
    local i = 0
    for a,b,c,d,e,f in iter do
      if i >= count then return end
      self:yield(a,b,c,d,e,f)
      i = i + 1
    end
  end
}

local _skip = generator {
  gen = function(self, count, iter)
    local i = 0
    for a,b,c,d,e,f in iter do
      if i >= count then
        self:yield(a,b,c,d,e,f)
      end
      i = i + 1
    end
  end
}

local _zip = generator {
  gen = function(self, iter1, iter2)
    local item1, item2 = 1
    while item1 or item2 do
      item1 = iter1()
      item2 = iter2()
      self:yield(item1, item2)
    end
  end
}


local _bind = function(func, ...) return binder:new(func, ...) end
local functional = {
  id      = _id,
  bind    = _bind,
  compose = _compose,

  zip    = _zip,
  map    = _map,
  filter = _filter,
  foldl  = _foldl,
  foldr  = not_implemented,

  range   = _range,
  xrange  = _range,
  xrepeat = _xrepeat,
  take    = _take,
  skip    = _skip,

  zeroes = _bind(_xrepeat, 0),
  ones   = _bind(_xrepeat, 1),
}

return functional
