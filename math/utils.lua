local utils = require 'lulz.private.utils'


-- lulz.math can be used as standard math or replace it
local math = utils.clone(math)

function math.sign(x)
  assert(type(x) == 'number')
  if x < 0 then return -1 end
  return 1
end


return math
