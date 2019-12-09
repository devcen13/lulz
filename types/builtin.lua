local _type = require 'lulz.types.type'

local builtin = {}


local function builtin_new(data)
  return function(_, value)
    if value == nil then return data.default() end
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
  default = function() return nil end,
  convert = function() return nil end
})

builtin_type('boolean', {
  default = function() return false end,
  convert = function(v) return not not v end
})

builtin_type('number', {
  default = function() return 0 end,
})

builtin_type('table', {
  default = function() return {} end,
})

builtin_type('string', {
  default = function() return '' end,
  convert = tostring
})

builtin_type('function', {
  default = function() return function() end end
})

builtin_type('thread')
builtin_type('userdata')


--[[ Subtypes ]]
builtin_type('int', {
  default = function() return 0 end,
  convert = math.floor,
  isinstance = function(v) return type(v) == 'number' and math.floor(v) == v end
})

builtin_type('float', {
  default = function() return 0.0 end,
  convert = function(v) return v + 0.0 end,
  isinstance = builtin_isinstance 'number'
})

builtin_type('any', {
  default = function() return nil end,
  convert = function(v) return v end,
  isinstance = function() return true end
})


--[[ Aliases ]]
builtin.str = builtin.string
builtin.bool = builtin.boolean
builtin.func = builtin['function']


return builtin
