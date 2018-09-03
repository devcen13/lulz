local lulz = require 'lulz'
local dict = require 'lulz.dict'

local clone, extend = dict.clone, dict.extend

local error = error
local smt, gmt = setmetatable, getmetatable

--[[ Classes registry ]]
local __classes__ = {}

if lulz.debug then
  rawset(_G, '__classes__', __classes__)
end

--[[ Keyword setters ]]
local function _private(method)
  return {
    get = function() return nil end, -- rawget must work!
    set = function()
      error('Property ' .. method .. ' is private.')
    end
  }
end

local function _metamethod(method)
  return {
    get = function(class) return class.__meta__[method] end, -- rawget must work!
    set = function(class, value)
      assert(type(value) == 'function', 'Metamethods must be functions.')
      class.__meta__[method] = value
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

local function _rawset(method)
  return {
    get = nil,
    set = function(class, value)
      rawset(class, method, value)
    end
  }
end

local keywords = {
  __mixin__         = _private('__mixin__'), -- reserved
  __init__          = _rawset('__init__'),

  __init_subclass__ = _rawset('__init_subclass__'),
  __class_call__    = _classmeta('__call'),

  __name__     = _private('__name__'),
  __meta__     = _private('__meta__'),
  __static__   = _private('__static__'),
  __getters__  = _private('__getters__'),
  __setters__  = _private('__setters__'),
  __methods__  = _private('__methods__'),
  __abstract__ = _private('__abstract__'),

  __call__  = _metamethod('__call'),
  __str__   = _metamethod('__tostring'),
  __len__   = _metamethod('__len'),
  __iter__  = _metamethod('__ipairs'),
  __items__ = _metamethod('__pairs'),
  __del__   = _metamethod('__gc'),

  __unm__    = _metamethod('__unm'),
  __add__    = _metamethod('__add'),
  __sub__    = _metamethod('__sub'),
  __mul__    = _metamethod('__mul'),
  __div__    = _metamethod('__div'),
  __mod__    = _metamethod('__mod'),
  __pow__    = _metamethod('__pow'),
  __concat__ = _metamethod('__concat'),

  __eq__ = _metamethod('__eq'),
  __lt__ = _metamethod('__lt'),
  __le__ = _metamethod('__le'),
}

--[[ Set attribute ]]
local function _try_add_property(class, name, prop)
  if type(prop) ~= 'table' or prop.__type__ ~= '__property__' then return false end
  class.__getters__[name] = prop.get or function() error('Attempt to set readonly property ' .. name) end
  class.__setters__[name] = prop.set or function() error('Attempt to get private property ' .. name) end
  return true
end

local function _try_add_method(class, name, prop)
  if type(prop) ~= 'function' then return false end
  class.__methods__[name] = prop
  return true
end

local function _set_attribute(class, k, v)
  if keywords[k] then
    return keywords[k].set(class, v)
  end
  if _try_add_property(class, k, v) then return end
  if _try_add_method  (class, k, v) then return end
  rawset(class.__static__, k, v)
end

--[[ Get attribute ]]
local function _get_attribute(class, key)
  if keywords[key] and keywords[key].get then
    return keywords[key].get(class)
  end

  if class.__methods__[key] then return class.__methods__[key]   end
  if class.__static__[key]  then return class.__static__[key]    end

  local super = rawget(class, '__super__')
  if super then return super[key]     end
end

--[[ Class construction ]]
local function _metatable(super)
  return super and clone(super.__meta__) or {
    __newindex = function(inst, k, v)
      local setters = inst.__type__.__setters__
      if setters[k] then return setters[k](inst, v) end
      local static = inst.__type__.__static__
      if static[k] then static[k] = v; return end
      rawset(inst, k, v)
    end,
    __index    = function(inst, k)
      local getters = inst.__type__.__getters__
      if getters[k] then return getters[k](inst) end
      return inst.__type__[k]
    end,
  }
end

local function _statictable(super)
  local static_meta = {
    __newindex = super and super.__static__ or function() error('Statics must be declared in class data block') end
  }

  return smt({}, static_meta)
end

local function _class_string(class)
  return 'class<' .. class.__name__ .. '>'
end

local function _extend_class(class, data)
  data = type(data) == 'table' and data or {}
  for k,v in pairs(data or {}) do
    class[k] = v
  end
  return class
end

local builder = {}

function builder.classtable(name, super)
  local class = {
    __super__ = super,
    inherit   = builder.inherit,
    new       = builder.new,

    __init__ = function(...) super.__init__(...) end,

    __name__     = name,
    __meta__     = _metatable(super),
    __static__   = _statictable(super),
    __methods__  = super and clone(super.__methods__)  or {},
    __getters__  = super and clone(super.__getters__)  or {},
    __setters__  = super and clone(super.__setters__)  or {},
  }
  return smt(class, {
    __newindex = _set_attribute,
    __index    = _get_attribute,
    __tostring = _class_string,
    __call     = _extend_class,
  })
end

function builder.inherit(base_type, data)
  local name = type(data) == 'string' and data or '<anonimous>'
  local inherited = builder.classtable(name, base_type)
  _extend_class(inherited, data)

  local init = base_type['__init_subclass__']
  if init then init(inherited, data) end
  return inherited
end

function builder.new(cls, ...)
  local instance = smt(clone(cls.__methods__), cls.__meta__)
  rawset(instance, '__type__', cls)
  local init = rawget(cls, '__init__')
  if init then init(instance, ...) end
  return instance
end

--[[ Root base class ]]
local object = builder.classtable('object')
function object.__init__()
  -- nothing here (at the moment)
end


--[[ Public API ]]
local class = smt({}, {
  __call = function(_, class_tbl)
    return object:inherit(class_tbl)
  end
})

function class.is_base_of(base, cls)
  if type(cls) ~= 'table' then return false end
  if cls == base then return true end
  return class.is_base_of(cls.__super__, base)
end

function class.is_instance(instance, cls)
  if type(instance) ~= 'table' then return false end
  return class.is_base_of(cls, instance.__type__)
end

function class.property(prop_tbl)
  return extend(prop_tbl, { __type__ = '__property__' })
end

return class
