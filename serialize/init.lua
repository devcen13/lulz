
local sz = require 'lulz.serialize.core'

require 'lulz.serialize.builtin'

sz.schema = require 'lulz.serialize.schema'

local declarations = require 'lulz.serialize.declarations'
sz.field = declarations.field
sz.list  = declarations.list


return sz
