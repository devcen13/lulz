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

local function _inherit_struct_type(super, data)
  if types.isinstance(data, types.str) then
    data = { __name__ = data }
  end

  for k, v in pairs(super) do
    if k:sub(1, 2) ~= '__' and rawget(data, k) == nil then
      data[k] = v
    end
  end

  return struct.new(nil, data, super)
end


function struct.new(_, data, super)
  if types.isinstance(data, types.str) then
    data = { __name__ = data }
  end
  local str = types.declare(data.__name__ or 'anonimous', struct_mt)
  str.__type__ = struct

  rawset(str, '__index', str)
  rawset(str, 'new',     _create_struct_inst)
  rawset(str, 'inherit', _inherit_struct_type)
  if super ~= nil then
    rawset(str, '__super__', super)
    rawset(str, '__implements__', setmetatable({}, { __index = super.__implements__ }))
  end

  for k, v in pairs(data) do
    str[k] = v
  end

  return str
end


return struct

