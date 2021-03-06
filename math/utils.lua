local clonable = require 'lulz.types.interfaces.clonable'

-- lulz.math can be used as standard math or replace it
local math = clonable.clone(math)

math.inf = tonumber('inf')

function math.sign(x, eps)
  eps = eps or 0
  if x < eps then return -1 end
  if x > eps then return  1 end
  return 0
end

function math.clamp(val, min, max)
  if val > max then return max end
  if val < min then return min end
  return val
end

function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


return math
