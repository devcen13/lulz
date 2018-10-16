local str = require 'lulz.str'
local fn = require 'lulz.functional'
local list = require 'lulz.list'
local utils = require 'lulz.private.utils'

local TestCase = require 'lulz.testcase'


local TestStrJoin = TestCase:inherit 'Str Join'

function TestStrJoin:test_empty_separator_join()
  self:assert_equal(str.join('', {'a', 'b', 'c'}), 'abc')
end

function TestStrJoin:test_space_separator_join()
  self:assert_equal(str.join(' ', {'a', 'b', 'c'}), 'a b c')
end

function TestStrJoin:test_numbers_join()
  self:assert_equal(str.join(' ', {0, 1, 2}), '0 1 2')
end

function TestStrJoin:test_boolean_join()
  self:assert_equal(str.join(' ', {false, true}), 'false true')
end

function TestStrJoin:test_iterator_join()
  self:assert_equal(str.join(' ', fn.range(3)), '1 2 3')
end


local TestStrSplit = TestCase:inherit 'Str Split'

TestStrSplit.test_words = TestCase.args_test {
  call = function(self, text, words)
    self:assert_equal(list:new(str.words(text)), list(words))
  end,
  argsset = {
    { 'aa, bb,dd  i', { 'aa,', 'bb,dd', 'i' } },
    {
[[
  aaa b  c    d
  aaa bbbb
]],
      {'aaa', 'b', 'c', 'd', 'aaa', 'bbbb'}
    }
  }
}

TestStrSplit.test_lines = TestCase.args_test {
  call = function(self, text, lines)
    self:assert_equal(list:new(str.lines(text)), list(lines))
  end,
  argsset = {
    { 'aa, bb,dd  i', { 'aa, bb,dd  i' } },
    {
[[aaa b  c    d
aaa bbbb]],
      {'aaa b  c    d', 'aaa bbbb' }
    },
    {
[[
  aaa b  c    d

  aaa bbbb
]],
      {'  aaa b  c    d', '', '  aaa bbbb', '' }
    }
  }
}


local TestStrReplaceString = TestCase:inherit 'Test replace string with str'

function TestStrReplaceString:setup()
  self._string = utils.clone(string)
  utils.extend(string, str)
end

function TestStrReplaceString:teardown()
  utils.override(string, self._string)
  for k,_ in pairs(string) do
    if self._string[k] == nil then string[k] = nil end
  end
end

function TestStrReplaceString:test_self_join()
  self:assert_equal((' '):join({'a', 'b', 'c'}), 'a b c')
end

