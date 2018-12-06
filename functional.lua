local class = require 'lulz.class'
local op = require 'lulz.operators'
local iterator  = require 'lulz.iterator'
local generator = require 'lulz.generator'
local utils = require 'lulz.private.utils'

local sign = require('lulz.math').sign


local recursion_max_depth = 10000


local function _id(x)
  return x
end

local function _last(...)
  local values = { ... }
  return values[#values]
end

local _range = generator {
  gen = function(self, start, stop, step)
    if stop == nil then
      if start == 0 then return end
      stop = start
      start = sign(stop)
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
  gen = function(self, func, params)
    for a,b,c,d,e,f in iterator(params) do
      self:yield(func(a,b,c,d,e,f))
    end
  end
}

local _filter = generator {
  gen = function(self, func, params)
    for a,b,c,d,e,f in iterator(params) do
      if func(a,b,c,d,e,f) then
        self:yield(a,b,c,d,e,f)
      end
    end
  end
}

local function _foldl(func, iter, accum)
  if type(func) == 'string' then func = op[func] end
  for v in iterator.values(iter) do
    if accum == nil then
      accum = v
    else
      accum = func(accum, v)
    end
  end
  return accum
end

local function _foldr_cached(func, iter, accum)
  local cache = {}
  local i = 0
  for v in iter do
    table.insert(cache, v)
    i = i + 1
  end

  while i > 0 do
    if accum == nil then
      accum = cache[i]
    else
      accum = func(cache[i], accum)
    end
    i = i - 1
  end

  return accum
end

local function _foldr_recursive(func, iter, accum, i)
  local item = iter()
  if item == nil then return accum end
  if i > recursion_max_depth then
    accum = _foldr_cached(func, iter, accum)
  else
    accum = _foldr_recursive(func, iter, accum, i + 1)
  end
  if accum == nil then return item end
  return func(item, accum)
end

local function _foldr(func, iter, accum)
  if type(func) == 'string' then func = op[func] end
  return _foldr_recursive(func, iterator.values(iter), accum, 0)
end


local binder = class {
  __init__ = function(self, func, ...)
    self._func = func
    self._params = { ... }
  end,
  __call = function(self, ...)
    return self._func(self:_build_params(...))
  end,
  __eq = function(self, other)
    if self._func ~= other._func then return false end
    return utils.equals(self._params, other._params)
  end
}

function binder:_build_params(...)
  if #self._params == 0 then
    return ...
  end
  local params = {}
  for _,p in ipairs(self._params) do
    table.insert(params, p)
  end
  for _,p in ipairs { ... } do
    table.insert(params, p)
  end
  return unpack(params)
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
    for a,b,c,d,e,f in iterator(iter) do
      if i >= count then return end
      self:yield(a,b,c,d,e,f)
      i = i + 1
    end
  end
}

local _take_while = generator {
  gen = function(self, predicate, iter)
    for a,b,c,d,e,f in iterator(iter) do
      if not predicate(a,b,c,d,e,f) then return end
      self:yield(a,b,c,d,e,f)
    end
  end
}

local _skip = generator {
  gen = function(self, count, iter)
    local i = 0
    for a,b,c,d,e,f in iterator(iter) do
      if i >= count then
        self:yield(a,b,c,d,e,f)
      end
      i = i + 1
    end
  end
}

local _skip_while = generator {
  gen = function(self, predicate, iter)
    local first_found = false
    for a,b,c,d,e,f in iterator(iter) do
      if not first_found then
        first_found = not predicate(a,b,c,d,e,f)
      end
      if first_found then
        self:yield(a,b,c,d,e,f)
      end
    end
  end
}

local _reversed = generator {
  _gen_cached = function(self, iter)
    local a,b,c,d,e,f = iter()
    local cache = {}
    local i = 0
    while a ~= nil do
      i = i + 1
      table.insert(cache, { a,b,c,d,e,f })
      a,b,c,d,e,f = iter()
    end
    while i > 0 do
      self:yield(unpack(cache[i]))
      i = i - 1
    end
  end,
  _gen_recursive = function(self, iter, i)
    if i > recursion_max_depth then
      return self:_gen_cached(iter)
    end
    local a,b,c,d,e,f = iter()
    if a ~= nil then
      self:_gen_recursive(iter, i + 1)
      self:yield(a,b,c,d,e,f)
    end
  end,
  gen = function(self, iter)
    self:_gen_recursive(iterator(iter), 1)
  end
}

local _zip = generator {
  gen = function(self, iter1, iter2)
    iter1 = iterator(iter1)
    iter2 = iterator(iter2)

    local item1 = iter1()
    local item2 = iter2()
    while item1 ~= nil and item2 ~= nil do
      self:yield(item1, item2)
      item1 = iter1()
      item2 = iter2()
    end
  end
}

local function _any(predicate, iter)
  if iter == nil then
    iter = predicate
    predicate = _last
  end
  for a,b,c,d,e,f in iterator(iter) do
    if predicate(a,b,c,d,e,f) then return true end
  end
  return false
end

local function _all(predicate, iter)
  if iter == nil then
    iter = predicate
    predicate = _last
  end
  for a,b,c,d,e,f in iterator(iter) do
    if not predicate(a,b,c,d,e,f) then return false end
  end
  return true
end

local function _none(predicate, iter)
  if iter == nil then
    iter = predicate
    predicate = _last
  end
  for a,b,c,d,e,f in iterator(iter) do
    if predicate(a,b,c,d,e,f) then return false end
  end
  return true
end

local function _count(predicate, iter)
  if iter == nil then
    iter = predicate
    predicate = function() return true end
  end
  return _foldl('+', _map(function(...) return predicate(...) and 1 or 0 end, iter), 0)
end

local function _min(iter)
  local min = iter()
  for v in iter do
    if min > v then min = v end
  end

  return min
end

local function _max(iter)
  local max = iter()
  for v in iter do
    if max < v then max = v end
  end

  return max
end

local function _minmax(iter)
  local min = iter()
  local max = min
  for v in iter do
    if min > v then min = v end
    if max < v then max = v end
  end

  return min, max
end


local _bind = function(func, ...) return binder:new(func, ...) end
local functional = {
  recursion_max_depth = recursion_max_depth,

  id      = _id,
  bind    = _bind,
  compose = _compose,

  zip    = _zip,
  map    = _map,
  filter = _filter,
  foldl  = _foldl,
  foldr  = _foldr,

  range   = _range,
  xrange  = _range,
  xrepeat = _xrepeat,
  take    = _take,
  skip    = _skip,
  reversed = _reversed,

  take_while = _take_while,
  skip_while = _skip_while,

  zeroes = _bind(_xrepeat, 0),
  ones   = _bind(_xrepeat, 1),

  min    = _min,
  max    = _max,
  minmax = _minmax,

  any = _any,
  all = _all,
  none = _none,

  last = _last,
  count = _count
}

return functional
