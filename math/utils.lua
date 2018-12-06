local utils = require 'lulz.private.utils'


-- lulz.math can be used as standard math or replace it
local math = utils.clone(math)

function math.sign(x)
  assert(type(x) == 'number')
  if x < 0 then return -1 end
  return 1
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
