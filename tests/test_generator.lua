local generator = require 'lulz.generator'
local TestCase = require 'lulz.tests.testcase'

local TestGenerator = TestCase:inherit 'Generators'


function TestGenerator:test_empty_generator()
  local empty = generator {
    gen = function() end
  }
  local counter = 0
  for _ in empty() do
    counter = counter + 1
  end
  self:assert_equal(counter, 0)
end

function TestGenerator:test_single_value_generator()
  local gen = generator {
    gen = function(self) self:yield(42) end
  }

  local counter = 0
  for val in gen() do
    counter = counter + 1
    self:assert_equal(val, 42)
  end
  self:assert_equal(counter, 1)
end


function TestGenerator:test_range_generator()
  local range = generator {
    gen = function(self)
      local i = 0
      while i < 10 do
        self:yield(i)
        i = i+1
      end
    end
  }

  local counter = 0
  for i in range() do
    self:assert_equal(i, counter)
    counter = counter + 1
  end
  self:assert_equal(counter, 10)
end

function TestGenerator:test_generator_with_args()
  local range = generator {
    gen = function(self, bound)
      local i = 0
      while i < bound do
        self:yield(i)
        i = i+1
      end
    end
  }

  local counter = 0
  for i in range(42) do
    self:assert_equal(i, counter)
    counter = counter + 1
  end
  self:assert_equal(counter, 42)
end
