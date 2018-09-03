local generator = require 'lulz.generator'
local TestCase = require 'lulz.tests.testcase'

local yield = coroutine.yield


local TestGenerator = TestCase:inherit 'Generators'

function TestGenerator:test_empty_generator()
  local gen = function() end
  local empty = generator(gen)
  local counter = 0
  for _ in empty() do
    counter = counter + 1
  end
  self:assert_equal(counter, 0)
end

function TestGenerator:test_range_generator()
  local range_gen = function()
    local i = 0
    while i < 10 do yield(i); i = i+1 end
  end
  local range = generator(range_gen)

  local counter = 0
  for _ in range() do
    counter = counter + 1
  end
  self:assert_equal(counter, 10)
end

function TestGenerator:test_generator_with_args()
  local range_gen = function(bound)
    local i = 0
    while i < bound do yield(i); i = i+1 end
  end

  local range = generator(range_gen)

  local counter = 0
  for _ in range(42) do
    counter = counter + 1
  end
  self:assert_equal(counter, 42)
end
