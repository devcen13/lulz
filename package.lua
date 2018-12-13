
local function _package_loader(path)
  return function(_P, key)
    local fullpath = path .. '.' .. key
    local result, mod = pcall(function() return _P.loader(fullpath) end)
    if not result then return nil end

    rawset(_P, key, mod)
    return mod
  end
end


local function package(path)
  assert(type(path) == 'string')

  local package_mt = {
    __index    = _package_loader(path),
    __newindex = function (_, k)
      error("attempt to create package variable " .. k, 2)
    end
  }

  return setmetatable({ loader = require }, package_mt)
end


return package
