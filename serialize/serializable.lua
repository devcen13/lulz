local interface = require 'lulz.types.interface'


local serializable = interface:new {
  __name__ = 'serializable';

  serialize   = interface.impl_required;
  deserialize = interface.impl_required;

  trivially_serializable = function() return false end
}


return serializable
