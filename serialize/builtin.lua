local builtin = require 'lulz.types.builtin'
local sz = require 'lulz.serialize.core'

local builtin_types = {
  builtin.bool,
  builtin.number,
  builtin.str
}

for _,tp in ipairs(builtin_types) do
  sz.serializable:impl(tp, {
    serialize   = function(_, obj) return obj end;
    deserialize = function(_, obj) return obj end;

    trivially_serializable = function() return true end
  })
end


sz.serializable:impl(builtin.table, {
  serialize   = function(_, tbl)
    local result = {}
    for k,v in pairs(tbl) do
      result[k] = sz.serialize(v)
    end
    return result
  end;
  deserialize = function(_, tbl)
    local result = {}
    for k,v in pairs(tbl) do
      result[k] = sz.deserialize(v)
    end
    return result
  end;

  trivially_serializable = function() return true end
})
