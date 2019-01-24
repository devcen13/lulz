local types = require 'lulz.types'

local abstract = types.declare 'abstract'

function abstract.new(_, tp)
  assert(types.istype(tp))
  return {
    __type__ = abstract,
    __expect__ = tp
  }
end

return abstract
