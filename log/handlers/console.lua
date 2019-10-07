local Handler = require 'lulz.log.handlers.handler'


local ConsoleHandler = Handler:inherit { }


function ConsoleHandler:__init__(params)
  params = params or {}
  Handler.__init__(self, params)
  self.colored = true
  if params.colored ~= nil then
    self.colored = params.colored
  end
end

function ConsoleHandler:write(lvl, prefix, msg)
  if self.colored then msg = lvl.color .. prefix .. '\27[0m' .. msg end
  print(msg)
end

return ConsoleHandler
