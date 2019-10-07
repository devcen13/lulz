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

  print('')
end

function Handler:log(lvl, msg)
  local params = {
    lvl  = lvl.fmt,
    time = os.date("%H:%M:%S"),
  }
  
  local info = debug.getinfo(2, "Sl")
  params.file = info.short_src
  params.line = info.currentline

  self:write(lvl, str.interpolate(self.format, params), msg)
end

function Handler:write()
  assert(false, 'Not implemented handler')
end

return Handler
