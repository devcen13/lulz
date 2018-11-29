local types = require 'lulz.types'
local builder = require 'lulz.class.builder'


local class = require 'lulz.class.type'

class.property = require 'lulz.class.property'
class.abstract = require 'lulz.class.abstract'


class.abstract_method = function()
  return class.abstract(types.func)
end

class.abstract_property = function()
  return class.abstract(class.property)
end


function class.new(_, class_tbl)
  return builder.build(class_tbl)
end


return class
