local types = require 'lulz.types'


local property = types.declare 'property'


local function _base_property()
  return {
    __type__ = property
  }
end

local function _typed_property(tp, default)
  local p = _base_property()
  p.init = function(self, name)
    p.__name__ = '__' .. name
    if not types.isinstance(default, tp) then
      default = tp:new(default)
    end
    self[p.__name__] = default
  end
  p.set = function(self, value)
    if not types.isinstance(value, tp) then
      value = tp:new(value)
    end
    self[p.__name__] = value
  end
  p.get = function(self)
    return self[p.__name__]
  end

  return p
end

local function _custom_property(prop)
  local p = _base_property()
  p.init = prop.init
  p.get = prop.get
  p.set = prop.set
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
