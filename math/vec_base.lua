local types = require 'lulz.types'
local class = require 'lulz.types.class'
local I = require 'lulz.types.interfaces'


local vec_base = class {
  __get = function(self, k)
    return self._data[k]
  end,
  __set = function(self, k, v)
    self._data[k] = v
  end,

  __tostring = function(self)
    return self:dump()
  end,
}

vec_base.__class_call__ = vec_base.new

I.equatable:impl(vec_base)

I.displayable:impl(vec_base, {
  dump = function(v)
    return v.__type__.__name__ .. ' ' .. I.displayable.dump(v._data)
  end
})


vec_base.len = class.property {
  get = function(self) return self:dot(self) end
}

function vec_base.dot(a, b)
  return math.sqrt(vec_base.dot2(a, b))
end

function vec_base.dot2(a, b)
  assert(types.isinstance(a, vec_base))
  assert(types.isinstance(b, vec_base))
  assert(a.dimension == b.dimension)
  local sum = 0
  for i = 1,a.dimension do
    sum = sum + a[i] * b[i]
  end
  return sum
end

function vec_base.__unm(a)
  assert(types.isinstance(a, vec_base))
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, -a[i])
  end
  return a.__type__:new(result)
end

function vec_base.__add(a, b)
  assert(types.isinstance(a, vec_base))
  assert(types.isinstance(b, vec_base))
  assert(a.dimension == b.dimension)
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] + b[i])
  end
  return a.__type__:new(result)
end

function vec_base.__sub(a, b)
  assert(types.isinstance(a, vec_base))
  assert(types.isinstance(b, vec_base))
  assert(a.dimension == b.dimension)
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] - b[i])
  end
  return a.__type__:new(result)
end

function vec_base.__mul(a, b)
  if (type(a) == 'number') then
    return vec_base.__mul(b, a)
  end
  assert(types.isinstance(a, vec_base))
  assert(type(b) == 'number')
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] * b)
  end
  return a.__type__:new(result)
end

function vec_base.__div(a, b)
  assert(types.isinstance(a, vec_base))
  assert(type(b) == 'number')
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] / b)
  end
  return a.__type__:new(result)
end

function vec_base.__eq(a, b)
  if not types.isinstance(a, vec_base) then return false end
  if not types.isinstance(b, vec_base) then return false end
  if a.dimension ~= b.dimension then return false end
  for i = 1,a.dimension do
    if a[i] ~= b[i] then return false end
  end
  return true
end

return vec_base
