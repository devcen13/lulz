local class = require 'lulz.class'

local iterable = class 'iterable' {
  iter = class.abstract_method()
}

return iterable
