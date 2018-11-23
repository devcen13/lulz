local class = require 'lulz.class'

local I = {}

I.iterable = class {
  iter = class.abstract_method()
}

I.clonable = class {
  clone = class.abstract_method()
}

I.disposable = class {
  dispose = class.abstract_method()
}

return I
