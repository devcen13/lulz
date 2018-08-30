local abs = math.abs
local type, tostring = type, tostring


local function _compare_scalar(a, b, settings)
  if type(a) == 'number' then return abs(a - b)  < (settings.eps or 1.e-6) end
  return a == b
end

local function _compare_recursive(a, b, settings)
  local type_a = type(a)
  local type_b = type(b)
  settings = settings or {}

  if type_a ~= type_b  then return false end
  if (getmetatable(a) or {}).__eq then return a == b end
  if type_a ~= 'table' then return _compare_scalar(a, b, settings) end

  for k in pairs(a) do if b[k] == nil then return false end end
  for k in pairs(b) do if a[k] == nil then return false end end
  for k,v in pairs(a) do
    if not _compare_recursive(v, b[k]) then return false end
  end

  return true
end


local function _dump_recursive(t)
  if type(t) ~= 'table' then return tostring(t) end
  local str = '{ '
  local comma = ''
  for k, v in pairs(t) do
    str = str .. comma .. '[' .. _dump_recursive(k) .. '] = ' .. _dump_recursive(v)
    comma = ', '
  end
  return str .. ' }'
end


local function _clone_recursive(t)
  if type(t) ~= 'table' then return t end
  local meta = getmetatable(t)
  local target = {}
  for k, v in pairs(t) do
    if type(v) == 'table' then
      target[k] = _clone_recursive(v)
    else
      target[k] = v
    end
  end
  setmetatable(target, meta)
  return target
end


local override = 0
local add_keys = 1
local clone_new_items = 2

local function _extend_recursive(base, overrides, policy)
  if type(base) ~= 'table' then return base end
  if type(overrides) ~= 'table' then return base end
  policy = policy ~= nil and policy or add_keys

  for k, v in pairs(overrides) do
    if type(v) == 'table' and type(base[k]) == 'table' then
      _extend_recursive(base[k], v, policy)
    else
      if base[k] ~= nil or policy ~= override then
        if policy == clone_new_items then
          v = _clone_recursive(v)
        end
        base[k] = v
      end
    end
  end

  return base
end


local tablex = {
  equals = _compare_recursive,
  dump   = _dump_recursive,
  clone  = _clone_recursive,
  extend = _extend_recursive,

  override = override,
  add_keys = add_keys,
  clone_new_items = clone_new_items,
}

return tablex