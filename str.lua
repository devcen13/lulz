local utils = require 'lulz.private.utils'
local fn = require 'lulz.functional'
local generator = require 'lulz.generator'


-- str module can be used instead of standard string library or replace it
local str = setmetatable({}, { __index = string })

str.split = generator {
  gen = function(self, text, pattern, settings)
    settings = utils.override({ use_regex = false, skip_empty = false }, settings)
    pattern = settings.use_regex and pattern or '[^' .. pattern .. ']'

    for match in text:gmatch(pattern) do
      if not settings.skip_empty or match:len() > 0 then
        self:yield(match)
      end
    end
  end
}

function str.join(sep, iterable)
  return fn.foldl(function(a, b) return tostring(a) .. sep .. tostring(b) end, iterable) or ''
end

function str.words(text)
  return str.split(text, '%S+', { use_regex = true, skip_empty = true })
end

function str.lines(text, skip_empty)
  return str.split(text .. '\n', '([^\r\n]*)\r?\n', { use_regex = true, skip_empty = skip_empty })
end


return str
