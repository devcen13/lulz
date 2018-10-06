local class = require 'lulz.class'
local iterator = require 'lulz.private.iterator'
local iterable = require 'lulz.iterable'
local generator = require 'lulz.generator'


iterator.empty = function()
  return function() end
end

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
  if iter == nil then return iterator.empty() end -- nil returning empty itera
  if class.is_instance(iter, iterator) then return iter end
  if class.is_instance(iter, iterable) then return iter:iter() end
  return iterator.pairs(iter)
end

return iterator
