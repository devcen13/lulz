local types = require 'lulz.types'


local struct = types.declare 'struct'


local struct_mt = {
  __tostring = function(self)
    return 'struct<' .. self.__name__ .. '>'
  end,
  __eq = function(self, other)
    return self.__id__ == other.__id__
  end
}

local function _create_struct_inst(type, ...)
  local instance = setmetatable({ __type__ = type }, type)

  local init = rawget(type, '__init__')
  if init then init(instance, ...) end

  return instance
end


function struct.new(_, data)
  if types.isinstance(data, types.str) then
    data = { __name__ = data }
  end
  local str = types.declare(data.__name__ or 'anonimous', struct_mt)
  str.__type__ = struct

  rawset(str, '__index', str)
  rawset(str, 'new',     _create_struct_inst)
  for k, v in pairs(data) do
    str[k] = v
  end

  return str
end


return struct

