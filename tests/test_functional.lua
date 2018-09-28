local generator = require 'lulz.generator'
local fn = require 'lulz.functional'

local TestCase = require 'lulz.tests.testcase'


local TestBind = TestCase:inherit 'Functional Bind'

function TestBind:test_id_bind()
  self:assert_equal(fn.bind(fn.id)(5), 5)
end

function TestBind:test_single_argument_bind()
  self:assert_equal(fn.bind(fn.id, 5)(), 5)
end


local TestUtils = TestCase:inherit 'Functional Utils'

function TestUtils:test_single_argument_range()
  local counter = 0
  local last
  for i in fn.range(5) do
    last = i
    counter = counter + 1
  end
  self:assert_equal(counter, 5)
  self:assert_equal(last, 5)
end

function TestUtils:test_start_stop_arguments_range()
  local counter = 0
  local last
  for i in fn.range(2, 5) do
    last = i
    counter = counter + 1
  end
  self:assert_equal(counter, 4)
  self:assert_equal(last, 5)
end

function TestUtils:test_start_stop_arguments_negative_range()
  local counter = 0
  local last
  for i in fn.range(2, 0) do
    last = i
    counter = counter + 1
  end
  self:assert_equal(counter, 3)
  self:assert_equal(last, 0)
end

function TestUtils:test_start_stop_step_arguments_range()
  local counter = 0
  local last
  for i in fn.range(2, 5, 0.5) do
    last = i
    counter = counter + 1
  end
  self:assert_equal(counter, 7)
  self:assert_equal(last, 5)
end

function TestUtils:test_start_stop_step_arguments_negative_range()
  local counter = 0
  local last
  for i in fn.range(2, 0, -2) do
    last = i
    counter = counter + 1
  end
  self:assert_equal(counter, 2)
  self:assert_equal(last, 0)
end

function TestUtils:test_xrepeat()
  local iters = 10000
  for i in fn.xrepeat(42) do
    self:assert_equal(i, 42)
    if iters < 0 then return end
    iters = iters - 1
  end
end

function TestUtils:test_zeroes()
  local iters = 10000
  for i in fn.zeroes() do
    self:assert_equal(i, 0)
    if iters < 0 then return end
    iters = iters - 1
  end
end

function TestUtils:test_ones()
  local iters = 10000
  for i in fn.ones() do
    self:assert_equal(i, 1)
    if iters < 0 then return end
    iters = iters - 1
  end
end

function TestUtils:test_take_xrepeat()
  local iters = 0
  for i in fn.take(100, fn.xrepeat(42)) do
    self:assert_equal(i, 42)
    iters = iters + 1
  end
  self:assert_equal(iters, 100)
end

function TestUtils:test_skip_range()
  local counter = 0
  local last
  for i in fn.skip(45, fn.range(50)) do
    last = i
    counter = counter + 1
  end
  self:assert_equal(counter, 5)
  self:assert_equal(last, 50)
end

function TestUtils:test_zip_equal()
  local counter = 0
  for a,b in fn.zip(fn.range(5), fn.range(5)) do
    self:assert_equal(a, b)
    counter = counter + 1
  end
  self:assert_equal(counter, 5)
end


local TestFilter = TestCase:inherit 'Functional Filter'

function TestFilter:test_filter_true()
  local iters = 0
  for _ in fn.filter(function(_) return true end, fn.range(100)) do
    iters = iters + 1
  end
  self:assert_equal(iters, 100)
end

function TestFilter:test_filter_false()
  local iters = 0
  for _ in fn.filter(function(_) return false end, fn.range(100)) do
    iters = iters + 1
  end
  self:assert_equal(iters, 0)
end

function TestFilter:test_filter_even()
  local iters = 0
  for i in fn.filter(function(i) return i % 2 == 0 end, fn.range(100)) do
    self:assert(i % 2 == 0)
    iters = iters + 1
  end
  self:assert_equal(iters, 50)
end

function TestFilter:test_filter_ipairs()
  local iters = 0
  local iprs = generator {
    gen = function(self)
      self:yield(1, 3)
      self:yield(2, 3)
      self:yield(3, 3)
      self:yield(1, 3)
      self:yield(5, 5)
      self:yield(8, 8)
    end
  }
  for i,v in fn.filter(function(i, v) return i == v end, iprs()) do
    self:assert(i == v)
    iters = iters + 1
  end
  self:assert_equal(iters, 3)
end
