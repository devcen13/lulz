local struct = require 'lulz.types.struct'
local str = require 'lulz.str'

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

function Logger:_log(lvl, fmt, params)
  if lvl.index < self.min_level then return end

  params = params or {}
  local msg = str.interpolate(fmt, params)
  meta_params = {
    __file__ = params.__file__;
    __line__ = params.__line__;
  }
  for _,handler in ipairs(self.handlers) do
    handler:log(lvl, msg, meta_params)
  end
end

function Logger:log(lvl, fmt, params)
  self:_log(lvl, fmt, params)
end


for i,level in pairs(LEVELS) do
  Logger[level.id] = level
  Logger[level.func] = function(self, fmt, ...)
    self:_log(level, fmt, ...)
  end
end


return Logger
