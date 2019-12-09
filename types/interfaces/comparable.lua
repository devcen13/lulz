local interface = require 'lulz.types.interface'


local comparable = interface:new {
  __name__ = 'comparable';
  compare = interface.impl_required
}


return comparable
