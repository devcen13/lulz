local types = require 'lulz.types'


local class = types.declare 'class'


function class.super(cls)
  return cls.__super__
end

function class.isbaseof(base, cls)
  if not class.isclass(base) then return false end
  if not class.isclass(cls) then return false end
  if cls == base then return true end

  if cls.__mixin__ ~= nil then
    for _,mixin in ipairs(cls.__mixin__) do
      if class.isbaseof(base, mixin) then return true end
    end
  end
  return class.isbaseof(base, cls.__super__)
end

function class.isclassinstance(instance, cls)
  if type(instance) ~= 'table' then return false end
  if not class.isclass(cls) then return false end
  return class.isbaseof(cls, instance.__type__)
end

function class.isclass(cls)
  return types.isinstance(cls, class)
end

function class.isabstract(cls)
  if not class.isclass(cls) then return false end
  return rawget(cls, '__abstract__') ~= nil
end


return class
