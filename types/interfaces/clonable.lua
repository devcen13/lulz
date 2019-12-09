local interface = require 'lulz.types.interface'
local builtins  = require 'lulz.types.builtin'


local clonable = interface:new {
  __name__ = 'clonable';
  clone = interface.impl_required
}


clonable:impl(builtins.table, {
  clone = function(tbl)
    local clone = {}
    for k,v in pairs(tbl) do
      if clonable.isinstance(v, clonable) then
        clone[k] = clonable.clone(v)
      else
        clone[k] = v
      end
    end
    return clone
  end
})

for _, tp in pairs(builtins) do
  if not clonable:isimplemented(tp) then
    clonable:impl(tp, {
      clone = function(obj) return obj end
    })
  end
end


return clonable
