local struct = require 'lulz.types.struct'
local sz = require 'lulz.serialize.core'

local schema = struct {
  __name__ = 'serialize.schema'
}

function schema:__init__(fields)
  self._fields = fields
end


local _schema_impl = {
  serialize = function(tp, obj)
    local obj_schema = tp.__schema__
    local result = {}
    for k,v in pairs(obj_schema._fields) do
      result[k] = v:serialize(obj[k])
    end
    return result
  end;

  deserialize = function(tp, data)
    local obj_schema = tp.__schema__
    local obj = tp:new()
    for k,v in pairs(obj_schema._fields) do
      obj[k] = v:deserialize(data[k])
    end
    return obj
  end
}

function schema:impl_serializable_struct(S)
  rawset(S, '__schema__', self)
  sz.serializable:impl(S, _schema_impl)
end


return schema
