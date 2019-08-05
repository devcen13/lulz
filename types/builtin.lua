local _type = require 'lulz.types.type'
local utils = require 'lulz.private.utils'

local builtin = {}


local function builtin_new(data)
  return function(_, value)
    if value == nil then return utils.clone(data.default) end
    if data.convert then return data.convert(value) end

    assert(data.isinstance(value))
    return value
  end
end

local function builtin_isinstance(name)
  return function(value)
    return type(value) == name
  end
end


local function builtin_type(name, data)
  data = data or {}
  data.isinstance = data.isinstance or builtin_isinstance(name)

  local tp = _type.declare(name)
  tp.new = builtin_new(data)
  tp.isinstance = data.isinstance

  builtin[name] = tp
end


builtin_type('nil', {
  default = nil,
  convert = function() return nil end
})

builtin_type('boolean', {
  default = false,
  convert = function(v) return not not v end
})

builtin_type('number', {
  default = 0,
})

builtin_type('table', {
  default = {},
})

builtin_type('string', {
  default = '',
  convert = tostring
})

builtin_type('function', {
  default = function() end
})

builtin_type('thread')
builtin_type('userdata')


--[[ Subtypes ]]
builtin_type('int', {
  default = 0,
  convert = math.floor,
  isinstance = function(v) return type(v) == 'number' and math.floor(v) == v end
})

builtin_type('float', {
  default = 0.0,
  convert = function(v) return v + 0.0 end,
  isinstance = builtin_isinstance 'number'
})

builtin_type('any', {
  default = nil,
  convert = function(v) return v end,
  isinstance = function() return true end
})


--[[ Aliases ]]
builtin.str = builtin.string
builtin.bool = builtin.boolean
builtin.func = builtin['function']


return builtin
