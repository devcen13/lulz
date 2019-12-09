local types = require 'lulz.types'
local I = require 'lulz.types.interfaces'
local generator = require 'lulz.generator'

local iterator = {}

iterator.empty = function() end

iterator.pairs = generator {
  gen = function(self, tbl)
    for k,v in pairs(tbl) do
      self:yield(k, v)
    end
  end
}

iterator.ipairs = generator {
  gen = function(self, tbl)
    for i,v in ipairs(tbl) do
      self:yield(i, v)
    end
  end
}

iterator.values = generator {
  gen = function(self, tbl)
    for a,b,c,d,e,f in iterator(tbl) do
      local values = { a,b,c,d,e,f }
      self:yield(values[#values])
    end
  end
}

iterator.concat = generator {
  gen = function(self, ...)
    for _,iter in ipairs { ... } do
      for a,b,c,d,e,f in iterator(iter) do
        self:yield(a,b,c,d,e,f)
      end
    end
  end
}


local create_iterator = function(_, iter)
  if iter == nil then return iterator.empty end
  if types.isinstance(iter, I.iterator) then return iter end
  if types.isinstance(iter, I.iterable) then return I.iterable.iter(iter) end
  return iterator.pairs(iter)
end

return setmetatable(iterator, { __call = create_iterator })
