local struct = require 'lulz.types.struct'
local ConsoleHandler = require 'lulz.log.handlers.console'

local config = require 'lulz.log.config'
local LEVELS = config.LEVELS


local Logger = struct {
  DEFAULT_HANDLER = ConsoleHandler
}


function Logger:__init__(params)
  params = params or {}

  self.handlers = {}
  self.min_level = 1000

  for _,handler in ipairs(params.handlers or { Logger.DEFAULT_HANDLER:new() }) do
    self:attach_handler(handler)
  end
end

function Logger:attach_handler(handler)
  table.insert(self.handlers, handler)
  self.min_level = math.min(self.min_level, handler.level)
end

function Logger:log(lvl, fmt, ...)
  if lvl.index < self.min_level then return end

  local msg = string.format(fmt, ...)
  for _,handler in ipairs(self.handlers) do
    handler:log(lvl, msg)
  end
end


for i,level in pairs(LEVELS) do
  Logger[level.id] = level
  Logger[level.func] = function(self, fmt, ...)
    self:log(level, fmt, ...)
  end
end


return Logger
