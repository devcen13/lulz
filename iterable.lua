local I = require 'lulz.interfaces'
local fn = require 'lulz.functional'
local iterable = I.iterable


local function _functional_call(func)
  return function(self, predicate, ...)
    if predicate ~= nil then
      return func(predicate, self:iter(), ...)
    end
    return func(self, ...)
  end
end


iterable.reversed = fn.reversed

iterable.map    = _functional_call(fn.map)
iterable.filter = _functional_call(fn.filter)

iterable.foldl = _functional_call(fn.foldl)
iterable.foldr = _functional_call(fn.foldr)

iterable.take = _functional_call(fn.take)
iterable.skip = _functional_call(fn.skip)

iterable.take_while = _functional_call(fn.take_while)
iterable.skip_while = _functional_call(fn.skip_while)

iterable.any   = _functional_call(fn.any)
iterable.all   = _functional_call(fn.all)
iterable.none  = _functional_call(fn.none)

iterable.count = _functional_call(fn.count)

return iterable
