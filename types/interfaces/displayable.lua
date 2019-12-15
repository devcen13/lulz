local interface = require 'lulz.types.interface'
local builtins  = require 'lulz.types.builtin'


local displayable = interface:new {
  __name__ = 'displayable';
  dump = function(obj) return tostring(obj) end
}

local function _safe_dump(obj)
  if displayable.isinstance(obj, displayable) then
    return displayable.dump(obj)
  end
  return tostring(obj)
end


displayable:impl(builtins.str, {
  dump = function(str) return string.format('%q', str) end
})

displayable:impl(builtins.table, {
  dump = function(t)
    if getmetatable(t) and getmetatable(t).__tostring then return tostring(t) end

    local str = '{ '
    local comma = ''
    local maxi = 0
    for i, v in ipairs(t) do
      str = str .. comma .. _safe_dump(v)
      comma = ', '
      maxi = i
    end
    for k, v in pairs(t) do
      if type(k) ~= 'number' or k > maxi then
        str = str .. comma .. '[' .. _safe_dump(k) .. '] = ' .. _safe_dump(v)
        comma = ', '
      end
    end
    return str .. ' }'
  end
})

for _, tp in pairs(builtins) do
  if not displayable:isimplemented(tp) then
    displayable:impl(tp)
  end
end

return displayable
