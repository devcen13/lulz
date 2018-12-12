local globals = {}


local _set_global = function(_, k)    return _G[k] end
local _get_global = function(_, k, v) _G[k] = v end

local _original_mt = {
  __index    = _get_global,
  __newindex = _set_global
}


function globals.lock()
  local _gmt = getmetatable(_G) or {}
  _original_mt.__index    = _gmt.__index    or rawget
  _original_mt.__newindex = _gmt.__newindex or rawset

  _gmt.__index = function (_, k)
    error("attempt to read undeclared variable " .. k, 2)
  end
  _gmt.__newindex = function (_, k, v)
    error("attempt to create global variable " .. k, 2)
  end

  setmetatable(_G, _gmt)
end


function globals.unlock()
  local _gmt = getmetatable(_G) or {}

  _gmt.__index    = _original_mt.__index    ~= rawget and _original_mt.__index    or nil
  _gmt.__newindex = _original_mt.__newindex ~= rawget and _original_mt.__newindex or nil

  _original_mt.__index    = _get_global
  _original_mt.__newindex = _set_global
  setmetatable(_G, _gmt)
end


return setmetatable(globals, _original_mt)
