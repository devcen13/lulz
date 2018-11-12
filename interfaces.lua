local class = require 'lulz.class'

local I = {}

I.iterable = class 'iterable' {
  iter = class.abstract_method()
}

I.clonable = class 'clonable' {
  clone = class.abstract_method()
}

I.disposable = class 'disposable' {
  dispose = class.abstract_method()
}

return I
