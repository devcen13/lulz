local types = require 'lulz.types'
local sz = require 'lulz.serialize.core'


local declarations = {}


declarations.field = types.declare 'serialize.field'

function declarations.field:new(info)
  if types.istype(info) then
    info = { type = info }
  end
  info.__type__ = self
  return setmetatable(info, self)
end

function declarations.field:serialize(field)
  assert(field == nil or types.isinstance(field, self.type))
  assert(field ~= nil or not self.required)
  return sz.serialize(field)
end


declarations.list = types.declare 'serialize.list'

function declarations.list:new(info)
  if types.istype(info) then
    info = { type = info }
  end
  info.__type__ = self
  return setmetatable(info, self)
end


return declarations
