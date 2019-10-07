local utils = require 'lulz.private.utils'
local fn = require 'lulz.functional'
local generator = require 'lulz.generator'


-- str module can be used instead of standard string library or replace it
local str = setmetatable({}, { __index = string })

str.split = generator {
  gen = function(self, text, pattern, settings)
    settings = utils.override({ use_regex = false, skip_empty = false }, settings)
    if not settings.use_regex then
      text = text .. pattern:sub(1,1)
      pattern = '([^' .. pattern .. ']*)' .. pattern:sub(1,1)
    end

    for match in text:gmatch(pattern) do
      if not settings.skip_empty or match:len() > 0 then
        self:yield(match)
      end
    end
  end
}

function str.interpolate(s, tbl)
  return (s:gsub('($%b{})', function(w) return tbl[w:sub(3, -2)] or w end))
end

function str.join(sep, iterable)
  return fn.foldl(function(a, b) return tostring(a) .. sep .. tostring(b) end, iterable) or ''
end

function str.words(text, skip_empty)
  return str.split(text, '%S+', { use_regex = true, skip_empty = skip_empty })
end

function str.lines(text, skip_empty)
  return str.split(text .. '\n', '([^\r\n]*)\r?\n', { use_regex = true, skip_empty = skip_empty })
end

-- @todo: Add str.endswith
function str.startswith(text, prefix)
  return text:sub(1, #prefix) == prefix
end


return str
