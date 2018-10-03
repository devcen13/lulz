local class = require 'lulz.class'


local function _vec2_data(args)
  if #args == 0 then return { 0, 0 } end
  if #args == 2 then return args end

  assert(#args == 1, 'Invalid argument')
  assert(type(args[1] == 'table'), 'Invalid argument')
  local arg = args[1]
  return {
    arg[1] ~= nil and arg[1] or arg.x,
    arg[2] ~= nil and arg[2] or arg.y,
  }
end

local vec2 = class 'vec2' {
  dimension = 2,

  __init__ = function(self, ...)
    rawset(self, '_data', _vec2_data { ... })
  end,

  __index__ = function(self, k)
    return self._data[k]
  end,
  __newindex__ = function(self, k, v)
    self._data[k] = v
  end,

  __str__ = function(self)
    return 'vec2 { ' .. self.x .. ', ' .. self.y .. ' }'
  end
}

vec2.__class_call__ = vec2.new


vec2.x = class.property {
  get = function(self) return self._data[1] end,
  set = function(self, value) self._data[1] = value end,
}

vec2.y = class.property {
  get = function(self) return self._data[2] end,
  set = function(self, value) self._data[2] = value end,
}

vec2.xy = class.property {
  get = function(self) return vec2:new(self._data[1], self._data[2]) end,
  set = function(self, value)
    self._data[1] = value[1] ~= nil and value[1] or value.x
    self._data[2] = value[2] ~= nil and value[2] or value.y
  end,
}

vec2.len = class.property {
  get = function(self) return self:dot(self) end
}

function vec2.dot(a, b)
  return math.sqrt(vec2.dot2(a, b))
end

function vec2.dot2(a, b)
  assert(class.is_instance(a, vec2))
  assert(class.is_instance(b, vec2))
  assert(a.dimension == b.dimension)
  local sum = 0
  for i = 1,a.dimension do
    sum = sum + a[i] * b[i]
  end
  return sum
end


return vec2
