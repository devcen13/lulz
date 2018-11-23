local registry = require 'lulz.types.registry'


local types = {}

types.type = require 'lulz.types.type'
types.declare = types.type.declare

for name, tp in pairs(require 'lulz.types.builtin') do
  types[name] = tp
end

types.find = registry.find


function types.isinstance(obj, tp)
  if rawget(tp, 'isinstance') then return tp.isinstance(obj, tp) end
  if type(obj) ~= 'table' then return false end
  return rawget(obj, '__type__') == tp
end

function types.istype(obj)
  return types.isinstance(obj, types.type)
end

function types.typeof(obj)
  local typename = type(obj)
  if typename ~= 'table' then return types[typename] end

  local tp = rawget(obj, '__type__')
  if tp and types.isinstance(tp, types.type) then
    return tp
  end

  return types.table
end


return types
