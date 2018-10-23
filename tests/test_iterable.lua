local fn = require 'lulz.functional'
local TestCase = require 'lulz.testcase'

local TestIterable = TestCase:inherit 'Iterable'

--- @todo: Add more tests
function TestIterable:test_count()
  self:assert_equal(fn.xrepeat(0):take(100):count(), 100)
end
