local registry = require 'lulz.types.registry'
local utils = require 'lulz.private.utils'


local type_mt = {
  __tostring = function(self)
    return 'type<' .. self.__name__ .. '>'
  end,
  __call = function(self, ...)
    return self:new(...)
  end,
  __eq = function(self, other)
    return self.__id__ == other.__id__
  end,
  __clone = function(self)
    return self
  end
}


local basetype = setmetatable({}, type_mt)
basetype.__type__ = basetype
basetype.__name__ = 'type'
basetype.__id__ = registry.add(basetype)

function basetype.isinstance(tp)
  if type(tp) ~= 'table' then return false end
  local id = rawget(tp, '__id__')
  return id ~= nil and registry.find(id).__id__ == id
end

function basetype.declare(name, meta)
  local tp = {
    __type__ = basetype,
    __name__ = name or 'anonimous'
  }
  tp.__id__ = registry.add(tp)

  meta = meta or utils.clone(type_mt)
  return setmetatable(tp, meta)
end

return basetype
