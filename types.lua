local lulz = require 'lulz'

local smt = setmetatable


local __types__ = {}

if lulz.debug then
  rawset(_G, '__types__', __types__)
end


local types = { }

function types.register(tp)
  table.insert(__types__, tp)
  return #__types__
end


local function _type_create(tp, value)
  if value == nil then return tp.default() end
  if types.typeof(value) == tp then return value end
  return tp.convert and tp.convert(value)
end

local function _type_string(tp)
  return 'type<' .. tp.__name__ .. '>'
end

local function _std_type(name, tbl)
  local tp = smt(tbl, {
    __call = _type_create,
    __tostring = _type_string
  })
  tp.__id__ = types.register(tp)
  tp.__name__ = name
  if tp.is_instance == nil then
    tp.is_instance = function(v) return type(v) == name end
  end
  return tp
end

types['nil'] = _std_type('nil', {
  default = function() return nil end,
  convert = function() return nil end
})

types.number = _std_type('number', {
  default = function() return 0 end,
})

types.boolean = _std_type('boolean', {
  default = function() return false end,
  convert = function(v) return not not v end
})

types.string = _std_type('string', {
  default = function() return '' end,
  convert = function(v) return tostring(v) end
})

types.table = _std_type('table', {
  default = function() return {} end
})

types['function'] = _std_type('function', {
  default = function() return function() end end
})

types['thread'] = _std_type('thread', {})
types['userdata'] = _std_type('userdata', {})

--[[ Aliases ]]
types.str = types.string
types.bool = types.boolean
types.func = types['function']

--[[ Subtypes ]]
types.int = _std_type('int', {
  default = function() return 0 end,
  convert = function(v) return math.floor(types.number(v)) end,
  is_instance = function(v) return type(v) == 'number' and math.floor(v) == v end
})

types.float = _std_type('float', {
  default = function() return 0.0 end,
  convert = function(v) return types.number(v) + 0.0 end,
  is_instance = function(v) return type(v) == 'number' end
})


function types.get_by_id(id)
  return __types__[id]
end

function types.is_type(tp)
  if type(tp) ~= 'table' then return false end
  return types.get_by_id(rawget(tp, '__id__')) == tp
end

function types.typeof(obj)
  if type(obj) ~= 'table' then return types[type(obj)] end
  if types.is_type(obj) then return types.type end  -- @todo
  if types.is_type(rawget(obj, '__type__')) then return obj.__type__ end
  return types.table
end

function types.is_instance(obj, tp)
  if not types.is_type(tp) then return false end
  return tp.is_instance(obj)
end

return types
