local types = require 'lulz.types'
local interface = require 'lulz.types.interface'


local serializable = interface:new {
  __name__ = 'serializable';

  serialize   = interface.impl_required;
  deserialize = interface.impl_required;

  trivially_serializable = function() return false end
}

local serializable_types = {}

local _serializable_impl = serializable.impl

function serializable:impl(type, data)
  _serializable_impl(self, type, data)
  local name = type.__name__
  assert(name ~= 'anonimous')
  assert(serializable_types[name] == nil)
  serializable_types[name] = type
end


local sz = {
  serializable = serializable
}

function sz.serialize(obj)
  local type = types.typeof(obj)
  local value = type:serialize(obj)

  if type:trivially_serializable() then
    return value
  end
  return { __type__ = type.__name__, __value__ = value }
end

function sz.deserialize(data)
  if type(data) == 'table' and data.__type__ then
    local type = serializable_types[data.__type__]
    assert(type ~= nil)
    return type:deserialize(data.__value__)
  end
  return types.typeof(data):deserialize(data)
end

return sz
