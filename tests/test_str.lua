local str = require 'lulz.str'
local fn = require 'lulz.functional'

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
