local types = require 'lulz.types'

local interface = types.declare 'interface'

interface.impl_required = function() assert(false, 'Implementation required') end


local interface_mt = {
  __tostring = function(self)
    return 'struct<' .. self.__name__ .. '>'
  end,
  __eq = function(self, other)
    return self.__id__ == other.__id__
  end,
  __newindex = function(self, k, v)
    assert(types.isinstance(k, types.str))
    assert(types.isinstance(v, types.func))

    self.__impl__[k] = v
  end
}


local function _impl_interface(self, type, impl)
  assert(type.__implements__[self.__id__] == nil, 'Interface cannot be implemented twice for the same type')
  assert(types.isinstance(type, types.type), 'Interface can be implemented only for type')
  assert(not types.isinstance(type, interface), 'Cannot implement interface for interface')
  impl = impl or {}

  for k,fn in pairs(self.__impl__) do
    if rawget(type, k) == nil then
      local impl_fn = impl[k] or fn
      assert(impl_fn ~= interface.impl_required)
      type[k] = impl_fn
    end
  end

  type.__implements__[self.__id__] = self
end


function interface.isinterface(tp)
  return types.isinstance(tp, interface)
end


function interface.isimplemented(self, tp)
  return tp.__implements__[self.__id__] ~= nil
end


local function _interface_isinstance(obj, int)
  local tp = types.typeof(obj)
  return int:isimplemented(tp)
end


function interface.new(_, data)
  if types.isinstance(data, types.str) then
    data = { __name__ = data }
  end
  local tr = types.declare(data.__name__ or 'anonimous', interface_mt)
  rawset(tr, '__type__', interface)
  rawset(tr, '__impl__', {})
  rawset(tr, 'impl',     _impl_interface)

  rawset(tr, 'isinstance',    _interface_isinstance)
  rawset(tr, 'isimplemented', interface.isimplemented)

  data.__name__ = nil
  for k,v in pairs(data) do
    tr[k] = v
  end

  return tr
end


return interface
