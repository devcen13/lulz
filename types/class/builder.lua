local types = require 'lulz.types'
local property = require 'lulz.types.class.property'
local abstract = require 'lulz.types.class.abstract'
local utils = require 'lulz.private.utils'

local class_type = require 'lulz.types.class.type'

local clone = utils.clone
local error = error
local smt, gmt = setmetatable, getmetatable

--[[ Keyword setters ]]
local function _private(method)
  return {
    set = function()
      error('Property ' .. method .. ' is private.')
    end
  }
end

local function _metamethod(method)
  return {
    set = function(class, value)
      assert(type(value) == 'function', 'Metamethods must be functions.')
      rawset(class, method, value)
    end
  }
end

local function _classmeta(method)
  return {
    get = function(class)
      local meta = gmt(class)
      return meta[method]
    end,
    set = function(class, value)
      assert(type(value) == 'function', 'Metamethods must be functions.')
      local meta = gmt(class)
      meta[method] = value
      smt(class, meta)
    end
  }
end

local keywords = {
  __id__       = _private('__id__'),
  __mixin__    = _private('__mixin__'),
  __name__     = _private('__name__'),
  __preinit__  = _private('__preinit__'),
  __abstract__ = _private('__abstract__'),
  __index      = _private('__index'),
  __newindex   = _private('__newindex'),
  new          = _private('new'),
  inherit      = _private('inherit'),

  __class_call__ = _classmeta('__call'),

  __set   = _metamethod('__set'),
  __get   = _metamethod('__get')
}

local builder = {}

function builder.add_abstract(class, key, value)
  if value.__expect__ == property and class.__properties__[key] then
    return
  end
  if types.isinstance(class[key], value.__expect__) then
    return
  end

  rawset(class, '__abstract__', rawget(class, '__abstract__') or {})
  class.__abstract__[key] = value
end

function builder.resolve_abstract(class, key, value)
  if rawget(class, '__abstract__') == nil then return end
  local abs = class.__abstract__[key]
  if abs == nil then return end

  if not types.isinstance(value, abs.__expect__) then
    error('Abstract type mismatch. Expected ' .. tostring(abs.__expect__)
      .. '. Got ' .. tostring(types.typeof(value)))
  end

  class.__abstract__[key] = nil
  if next(class.__abstract__) == nil then
    class.__abstract__ = nil
  end
end

function builder.add_property(class, key, value)
  class.__properties__[key] = value
  if rawget(value, 'attach') then
    value.attach(class, key, value)
  end
end

function builder.add_method(class, key, value)
  rawset(class, key, value)
end

function builder.add_attribute(class, key, value)
  if keywords[key] then
    return keywords[key].set(class, value)
  end
  if types.isinstance(value, abstract) then
    return builder.add_abstract(class, key, value)
  end

  builder.resolve_abstract(class, key, value)
  if types.isinstance(value, property) then
    return builder.add_property(class, key, value)
  end
  if types.isinstance(value, types.func) then
    return builder.add_method(class, key, value)
  end
  rawset(class, key, value)
end

function builder.add_mixin(class, mixin)
  for key, value in pairs(rawget(mixin, '__abstract__') or {}) do
    builder.add_abstract(class, key, value)
  end
  for key, value in pairs(mixin) do
    if types.isinstance(value, types.func) then
      builder.add_method(class, key, value)
    end
  end

  for key, value in pairs(mixin.__properties__) do
    builder.add_property(class, key, value)
  end
end

function builder.add_mixins(class, mixins)
  rawset(class, '__mixin__', mixins)
  for _,mixin in ipairs(mixins or {}) do
    builder.add_mixin(class, mixin)
  end
end


local function _get_static_attribute(class, k)
  if rawget(class, k) ~= nil then return class[k] end
  if rawget(class, '__mixin__') ~= nil then
    for _,mixin in ipairs(class.__mixin__) do
      if mixin[k] ~= nil then return mixin[k] end
    end
  end
  if rawget(class, '__super__') ~= nil then
    return _get_static_attribute(class.__super__, k)
  end
end

local function _get_attribute(inst, k)
  local class = inst.__type__
  local prop = class.__properties__[k]
  if prop then
    if not prop.get then
      error('Attempt to get private property ' .. k)
    end
    return prop.get(inst)
  end

  local static = _get_static_attribute(class, k)
  if static ~= nil then return static end

  if class.__get ~= nil then
    return class.__get(inst, k)
  end
end

local function _set_attribute(inst, k, v)
  local class = inst.__type__
  local prop = class.__properties__[k]
  if prop then
    if not prop.set then
      error('Attempt to set readonly property ' .. k)
    end
    return prop.set(inst, v)
  end

  return (class.__set or rawset)(inst, k, v)
end


local class_mt = {
  __tostring = function(self)
    return 'class<' .. self.__name__ .. '>'
  end,
  __eq = function(self, other)
    return self.__id__ == other.__id__
  end,
  __newindex = builder.add_attribute,
  __index = _get_static_attribute
}

function builder.classtable(name, super)
  local class = types.declare(name, clone(class_mt))

  class.__type__ = class_type
  rawset(class, '__name__',  name)
  rawset(class, '__super__', super)

  rawset(class, '__index',    _get_attribute)
  rawset(class, '__newindex', _set_attribute)
  rawset(class, '__properties__', {})

  rawset(class, 'isinstance', class_type.isclassinstance)
  rawset(class, 'inherit', builder.inherit)
  rawset(class, 'new', builder.new)

  if super then
    rawset(class, '__abstract__', clone(rawget(super, '__abstract__')))
    rawset(class, '__properties__', clone(super.__properties__))
  end


  for key, prop in pairs(super or {}) do
    if types.isinstance(prop, types.func) then
      builder.add_method(class, key, prop)
    end
  end

  return class
end


function builder.new(class, ...)
  if rawget(class, '__abstract__') ~= nil then
    error('Cannot instantiate abstract ' .. tostring(class)
          .. '\n\tAbstract: ' .. utils.dump(rawget(class, '__abstract__')))
  end

  local instance = setmetatable({ __type__ = class }, class)

  for name, prop in pairs(class.__properties__) do
    if prop.init then
      prop.init(instance, name)
    end
  end
  local init = rawget(class, '__init__')
  if init then init(instance, ...) end

  return instance
end

function builder.inherit(super, data)
  if types.isinstance(data, types.str) then
    data = { __name__ = data }
  end
  data = data or {}
  local class = builder.classtable(data.__name__ or 'anonimous', super)
  data.__name__ = nil

  if super and super['__init_subclass__'] then
    super['__init_subclass__'](class, data)
  end

  local mixins = data['__mixin__']
  if mixins ~= nil then
    assert(type(mixins) == 'table')
    builder.add_mixins(class, mixins)
    data['__mixin__'] = nil
  end

  for k, v in pairs(data) do
    builder.add_attribute(class, k, v)
  end

  return class
end

function builder.build(data)
  return builder.inherit(nil, data)
end


return builder
