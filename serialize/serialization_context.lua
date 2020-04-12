local struct = require 'lulz.types.struct'


local indentation_cache = setmetatable({}, {
  __index = function(cache, i)
    cache[i] = setmetatable({ [0] = '' }, {
      __index = function(self, j)
        self[j] = self[j - 1] .. i
        return self[j]
      end
    })
    return cache[i]
  end
})


local SerializationContext = struct:new 'SerializationContext'


function SerializationContext:__init__(opts)
  self._options = opts or {}
  self._options.indent = self._options.indent or '  '
  self._indents = indentation_cache[self._options.indent]
  self.current_indent = 0
end




return SerializationContext
