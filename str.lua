local fn = require 'lulz.functional'

local foldl = fn.foldl

local str = {}

function str.join(sep, iterable)
  return foldl(function(a, b) return tostring(a) .. sep .. tostring(b) end, iterable)
end

return str
