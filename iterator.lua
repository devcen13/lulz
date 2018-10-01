local class = require 'lulz.class'
local iterator = require 'lulz.private.iterator'
local iterable = require 'lulz.private.iterable'
local generator = require 'lulz.generator'


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


iterator.__class_call__ = function(_, iter)
  if class.is_instance(iter, iterator) then return iter end
  if class.is_instance(iter, iterable) then return iter:iter() end
  return iterator.pairs(iter)
end

return iterator
