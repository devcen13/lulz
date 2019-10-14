local struct = require 'lulz.types.struct'


local weakref = struct {
  __name__ = 'weakref';

  __call = function(self)
    return rawget(self, '__value__')
  end;

  __mode = 'v';
}


function weakref:__init__(obj)
  rawset(self, '__value__', obj)
end


return weakref
