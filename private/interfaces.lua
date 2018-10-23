local class = require 'lulz.class'

local I = {}

I.iterable = class 'iterable' {
  iter = class.abstract_method()
}

return I
