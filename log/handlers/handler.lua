local struct = require 'lulz.types.struct'
local str = require 'lulz.str'

local config = require 'lulz.log.config'


local Handler = struct 'Handler'


function Handler:__init__(params)
  self.level = config.DEFAULT_LEVEL
  self.format = config.DEFAULT_FORMAT

  params = params or {}
  if params.level then
    self.level = params.level
  end
  if params.format then
    self.format = params.format
  end
end

function Handler:log(lvl, msg, params)
  
  params = params or {}
  params.lvl  = lvl.fmt
  params.time = os.date("%H:%M:%S")
  
  if not params.__file__ then
    local info = debug.getinfo(4, "Sl")
    params.__file__ = info.short_src
    params.__line__ = info.currentline
  end

  self:write(lvl, str.interpolate(self.format, params), msg)
end

function Handler:write()
  assert(false, 'Not implemented handler')
end

return Handler
