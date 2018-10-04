local class = require 'lulz.class'
local vec2 = require 'lulz.math.vec2'


local function _vec3_data(args)
  if #args == 0 then return { 0, 0 } end
  if #args == 3 then return args end

  assert(#args == 1, 'Invalid argument')
  assert(type(args[1] == 'table'), 'Invalid argument')
  local arg = args[1]
  return {
    arg[1] ~= nil and arg[1] or arg.x,
    arg[2] ~= nil and arg[2] or arg.y,
    arg[3] ~= nil and arg[3] or arg.z,
  }
end


local vec3 = vec2:inherit 'vec3' {
  dimension = 3,

  __init__ = function(self, ...)
    rawset(self, '_data', _vec3_data { ... })
  end,
}

vec3.__class_call__ = vec3.new


vec3.z = class.property {
  get = function(self) return self._data[3] end,
  set = function(self, value) self._data[3] = value end,
}

vec3.yz = class.property {
  get = function(self) return vec2:new(self._data[2], self._data[3]) end,
  set = function(self, value)
    self._data[2] = value[1] ~= nil and value[1] or value.x
    self._data[3] = value[2] ~= nil and value[2] or value.y
  end,
}

vec3.xz = class.property {
  get = function(self) return vec2:new(self._data[1], self._data[3]) end,
  set = function(self, value)
    self._data[1] = value[1] ~= nil and value[1] or value.x
    self._data[3] = value[2] ~= nil and value[2] or value.y
  end,
}

vec3.xyz = class.property {
  get = function(self) return vec3:new(self._data[1], self._data[2], self._data[3]) end,
  set = function(self, value)
    self._data[1] = value[1] ~= nil and value[1] or value.x
    self._data[2] = value[2] ~= nil and value[2] or value.y
    self._data[3] = value[3] ~= nil and value[3] or value.z
  end,
}


return vec3
