local fn = require 'lulz.functional'


local str = {}

function str.join(sep, iterable)
  return fn.foldl(function(a, b) return tostring(a) .. sep .. tostring(b) end, iterable)
end

return str
