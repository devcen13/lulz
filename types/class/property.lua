local types = require 'lulz.types'


local property = types.declare 'property'


local function _base_property()
  return {
    __type__ = property
  }
end

local function _convert_typed_property_value(tp, value)
  if value == nil then return nil end
  if types.isinstance(value, tp) then return value end
  if tp.convert then return tp.convert(value) end
  return tp:new(value)
end

local function _typed_property(tp, default)
  local p = _base_property()
  p.init = function(self, name)
    p.__field_name__ = 'prop=' .. name
    self[p.__field_name__] = _convert_typed_property_value(tp, default)
  end
  p.set = function(self, value)
    self[p.__field_name__] = _convert_typed_property_value(tp, value)
  end
  p.get = function(self)
    return self[p.__field_name__]
  end

  return p
end

local function _custom_property(prop)
  local p = _base_property()
  p.init = prop.init
  p.get = prop.get
  p.set = prop.set
  p.attach = prop.attach
  return p
end

local function _value_property(value)
  local p = _base_property()
  p.init = function(self, name)
    self[name] = value
  end
  return p
end

local function _is_prop_table(prop)
  if type(prop) ~= 'table' then return end
  return prop.set or prop.get or prop.init
end


function property.new(_, prop, value)
  if types.istype(prop) then
    return _typed_property(prop, value)
  end

  if _is_prop_table(prop) then
    return _custom_property(prop)
  end

  return _value_property(prop)
end


return property
