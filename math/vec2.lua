local class = require 'lulz.class'

local vec_base = require 'lulz.math.vec_base'


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

local vec2 = vec_base:inherit {
  __name__ = 'vec2',
  dimension = 2,

  __init__ = function(self, ...)
    rawset(self, '_data', _vec2_data { ... })
  end,
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


return vec2
