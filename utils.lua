
local utils = {
  not_implemented = function(reason)
    error('Not implemented' .. (reason and (': ' .. reason) or ''))
  end,
  deleted = function(reason)
    return function() error(reason) end
  end
}

return utils
