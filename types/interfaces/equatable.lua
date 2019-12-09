local type = require 'lulz.types.type'
local interface = require 'lulz.types.interface'
local builtins  = require 'lulz.types.builtin'


local equatable = interface:new {
  __name__ = 'equatable';
  equals = function(a, b) return a == b end
}


equatable:impl(type)

equatable:impl(builtins.number, {
  equals = function(a, b, eps)
    if _G.type(b) ~= 'number' then return false end
    eps = eps or 1e-6
    return math.abs(a - b) < eps
  end
})

equatable:impl(builtins.float, {
  equals = function(a, b, eps)
    if _G.type(b) ~= 'number' then return false end
    eps = eps or 1e-6
    return math.abs(a - b) < eps
  end
})

equatable:impl(builtins.table, {
  equals = function(a, b)
    if (getmetatable(a) or {}).__eq then return a == b end
    for k in pairs(a) do if b[k] == nil then return false end end
    for k in pairs(b) do if a[k] == nil then return false end end
    for k,v in pairs(a) do
      if equatable.isinstance(v, equatable) then
        if not equatable.equals(v, b[k]) then return false end
      else
        if v ~= b[k] then return false end
      end
    end

    return true
  end
})

for _, tp in pairs(builtins) do
  if not equatable:isimplemented(tp) then
    equatable:impl(tp)
  end
end


return equatable
