local utils = require 'lulz.private.utils'
local class = require 'lulz.class'


local vec_base = class 'vec_base' {
  __index__ = function(self, k)
    return self._data[k]
  end,
  __newindex__ = function(self, k, v)
    self._data[k] = v
  end,

  __str__ = function(self)
    return self.__type__.__name__ .. ' ' .. utils.dump(self._data)
  end,
}

vec_base.__class_call__ = vec_base.new


vec_base.len = class.property {
  get = function(self) return self:dot(self) end
}

function vec_base.dot(a, b)
  return math.sqrt(vec_base.dot2(a, b))
end

function vec_base.dot2(a, b)
  assert(class.is_instance(a, vec_base))
  assert(class.is_instance(b, vec_base))
  assert(a.dimension == b.dimension)
  local sum = 0
  for i = 1,a.dimension do
    sum = sum + a[i] * b[i]
  end
  return sum
end

function vec_base.__unm__(a)
  assert(class.is_instance(a, vec_base))
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, -a[i])
  end
  return a.__type__:new(result)
end

function vec_base.__add__(a, b)
  assert(class.is_instance(a, vec_base))
  assert(class.is_instance(b, vec_base))
  assert(a.dimension == b.dimension)
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] + b[i])
  end
  return a.__type__:new(result)
end

function vec_base.__sub__(a, b)
  assert(class.is_instance(a, vec_base))
  assert(class.is_instance(b, vec_base))
  assert(a.dimension == b.dimension)
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] - b[i])
  end
  return a.__type__:new(result)
end

function vec_base.__mul__(a, b)
  if (type(a) == 'number') then
    return b * a
  end
  assert(class.is_instance(a, vec_base))
  assert(type(b) == 'number')
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] * b)
  end
  return a.__type__:new(result)
end

function vec_base.__div__(a, b)
  assert(class.is_instance(a, vec_base))
  assert(type(b) == 'number')
  local result = {}
  for i = 1,a.dimension do
    table.insert(result, a[i] / b)
  end
  return a.__type__:new(result)
end

function vec_base.__eq__(a, b)
  if not class.is_instance(a, vec_base) then return false end
  if not class.is_instance(b, vec_base) then return false end
  if a.dimension ~= b.dimension then return false end
  for i = 1,a.dimension do
    if a[i] ~= b[i] then return false end
  end
  return true
end

return vec_base
