local stack = require 'lulz.collections.stack'
local types = require 'lulz.types'
local class = require 'lulz.class'
local iterable = require 'lulz.iterable'
local fn = require 'lulz.functional'

local TestCase = require 'lulz.testcase'


local TestStack = TestCase:inherit 'Stack'

function TestStack:test_stack_create()
  local s = stack()
  self:assert(types.isinstance(s, stack))
end

function TestStack:test_new_stack_is_empty()
  local s = stack()
  self:assert(s:is_empty())
end

function TestStack:test_push_increases_size()
  local s = stack()
  s:push(1)
  self:assert_equal(s:count(), 1)
end

function TestStack:test_pop_decreases_size()
  local s = stack()
  s:push(1)
  s:pop()
  self:assert_equal(s:count(), 0)
end

function TestStack:test_pop_returns_pushed()
  local s = stack()
  s:push(0)
  s:push(1)
  self:assert_equal(s:pop(), 1)
end

function TestStack:test_top_does_not_decrease_size()
  local s = stack()
  s:push(1)
  s:top()
  self:assert_equal(s:count(), 1)
end

function TestStack:test_top_returns_pushed()
  local s = stack()
  s:push(0)
  s:push(1)
  self:assert_equal(s:top(), 1)
end

function TestStack:test_stack_is_iterable()
  self:assert(class.isbaseof(iterable, stack))
end

function TestStack:test_stack_iterator_pops()
  local s = stack()
  s:push(1)
  s:iter()()
  self:assert_equal(s:count(), 0)
end

TestStack.test_stack_iterator_runs_until_empty = TestCase.args_test {
  call = function(self, range)
    local s = stack()
    for i in fn.range(range) do
      s:push(i)
    end
    self:assert_equal(s:count(), range)

    for _ in s:iter() do end
    self:assert_equal(s:count(), 0)
  end,
  argsset = {
    { 1 },
    { 10 },
    { 100 },
    { 1000 }
  }
}

function TestStack:test_stack_can_be_pushed_while_iterating()
  local s = stack()
  s:push(64)
  local last = nil
  for i in s:iter() do
    if i % 2 == 0 then s:push(i / 2) end
    last = i
  end
  self:assert_equal(last, 1)
end

function TestStack:test_stack_rawset_disabled()
  local s = stack()
  s:push(64)
  self:expect_failure(function() s[0] = nil end)
end

function TestStack:test_stack_rawget_disabled()
  local s = stack()
  s:push(64)
  self:expect_failure(function() local _ = s[0] end)
end
