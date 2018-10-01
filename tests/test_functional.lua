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

function TestUtils:test_zero_range()
  local counter = 0
  for _ in fn.range(0) do
    counter = counter + 1
  end
  self:assert_equal(counter, 0)
end

function TestUtils:test_one_range()
  local counter = 0
  for _ in fn.range(1) do
    counter = counter + 1
  end
  self:assert_equal(counter, 1)
end

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

function TestUtils:test_any_empty()
  self:assert_false(fn.any({}))
  self:assert_false(fn.any(fn.id, {}))
end

function TestUtils:test_any_falses()
  self:assert_false(fn.any({ false, false, false }))
  self:assert_false(fn.any(fn.last, { false, false, false }))
end

function TestUtils:test_any_true()
  self:assert(fn.any({ true, false, false }))
  self:assert(fn.any(fn.last, { true, false, false }))
end

function TestUtils:test_any_iterator()
  self:assert(fn.any(fn.filter(function(v) return v == 5 end, fn.range(10))))
  self:assert_false(fn.any(fn.filter(function(v) return v == 50 end, fn.range(10))))
end

function TestUtils:test_any_is_lazy()
  local i = 0
  local pred = function(...)
    i = i + 1
    return fn.last(...)
  end
  self:assert(fn.any(pred, { true, false, false }))
  self:assert_equal(i, 1)
end

function TestUtils:test_all_empty()
  self:assert(fn.all({}))
  self:assert(fn.all(fn.id, {}))
end

function TestUtils:test_all_falses()
  self:assert_false(fn.all({ false, false, false }))
  self:assert_false(fn.all(fn.last, { false, false, false }))
end

function TestUtils:test_all_one_true()
  self:assert_false(fn.all({ true, false, false }))
  self:assert_false(fn.all(fn.last, { true, false, false }))
end

function TestUtils:test_all_all_trues()
  self:assert(fn.all({ true, true, true }))
  self:assert(fn.all(fn.last, { true, true, true }))
end

function TestUtils:test_all_iterator()
  self:assert(fn.all(function(v) return v > 0 end, fn.range(10)))
  self:assert_false(fn.all(function(v) return v == 5 end, fn.range(10)))
end

function TestUtils:test_all_is_lazy()
  local i = 0
  local pred = function(...)
    i = i + 1
    return fn.last(...)
  end
  self:assert_false(fn.all(pred, { true, false, false }))
  self:assert_equal(i, 2)
end

function TestUtils:test_count_length()
  self:assert_equal(fn.count({ false, 1, 'a', 5 }), 4)
end

function TestUtils:test_count_with_predicate()
  self:assert_equal(fn.count(function(_,v) return type(v) == 'number' end,
                            { false, 1, 'a', 5 }), 2)
end

function TestUtils:test_count_iterator()
  self:assert_equal(fn.count(fn.range(1000)), 1000)
end

function TestUtils:test_count_iterator_with_predicate()
  self:assert_equal(fn.count(function(v) return v % 3 == 0 end,
                            fn.range(1000)), 333)
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

function TestFilter:test_filter_empty()
  local iters = 0
  for _ in fn.filter(function(_) return true end, fn.range(0)) do
    iters = iters + 1
  end
  self:assert_equal(iters, 0)
end

function TestFilter:test_filter_true()
  local iters = 0
  for _ in fn.filter(function(_) return true end, fn.range(100)) do
    iters = iters + 1
  end
  self:assert_equal(iters, 100)
end

function TestFilter:test_filter_table()
  local iters = 0
  for _ in fn.filter(function(_, i) return i % 2 == 0 end, { 0, 1, 2, 3, 4, 5, 6 }) do
    iters = iters + 1
  end
  self:assert_equal(iters, 4)
end

function TestFilter:test_filter_table_by_key()
  local iters = 0
  local values = {
    a = 1,
    b = 2,
    cc = 2,
    ccc = 3,
    cdc = 2
  }
  for _ in fn.filter(function(k, v) return #k == v end, values) do
    iters = iters + 1
  end
  self:assert_equal(iters, 3)
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
    gen = function(inst)
      inst:yield(1, 3)
      inst:yield(2, 3)
      inst:yield(3, 3)
      inst:yield(1, 3)
      inst:yield(5, 5)
      inst:yield(8, 8)
    end
  }
  for i,v in fn.filter(function(i, v) return i == v end, iprs()) do
    self:assert(i == v)
    iters = iters + 1
  end
  self:assert_equal(iters, 3)
end


local TestMap = TestCase:inherit 'Functional Map'

function TestMap:test_map_empty()
  local iters = 0
  for _ in fn.map(fn.id, fn.range(0)) do
    iters = iters + 1
  end
  self:assert_equal(iters, 0)
end

function TestMap:test_map_id()
  local iters = 0
  for val in fn.map(fn.id, fn.range(30)) do
    iters = iters + 1
    self:assert_equal(val, iters)
  end
  self:assert_equal(iters, 30)
end

function TestMap:test_map_table()
  local iters = 0
  local values = {
    a = 1,
    b = 2,
    c = 3,
    d = 4
  }
  for key,val in fn.map(function(k, _) return k,k end, values) do
    iters = iters + 1
    self:assert_equal(val, key)
  end
  self:assert_equal(iters, 4)
end

function TestMap:test_map_square()
  local iters = 0
  for val in fn.map(function(v) return v^2 end, fn.range(30)) do
    iters = iters + 1
    self:assert_equal(val, iters ^ 2)
  end
  self:assert_equal(iters, 30)
end
