local queue = require 'lulz.collections.queue'
local class = require 'lulz.class'
local types = require 'lulz.types'
local iterable = require 'lulz.iterable'
local fn = require 'lulz.functional'

local TestCase = require 'lulz.testcase'


local TestQueue = TestCase:inherit 'Queue'

function TestQueue:test_queue_create()
  local q = queue()
  self:assert(types.isinstance(q, queue))
end

function TestQueue:test_new_queue_is_empty()
  local q = queue()
  self:assert(q:is_empty())
end

function TestQueue:test_enqueue_increases_size()
  local q = queue()
  q:enqueue(1)
  self:assert_equal(q.size, 1)
end

function TestQueue:test_dequeue_decreases_size()
  local q = queue()
  q:enqueue(1)
  q:dequeue()
  self:assert_equal(q.size, 0)
end

function TestQueue:test_dequeue_returns_enqueued()
  local q = queue()
  q:enqueue(1)
  q:enqueue(0)
  self:assert_equal(q:dequeue(), 1)
end

function TestQueue:test_next_does_not_decrease_size()
  local q = queue()
  q:enqueue(1)
  q:next()
  self:assert_equal(q.size, 1)
end

function TestQueue:test_next_returns_enqueued()
  local q = queue()
  q:enqueue(1)
  q:enqueue(0)
  self:assert_equal(q:next(), 1)
end

function TestQueue:test_queue_is_iterable()
  self:assert(class.isbaseof(iterable, queue))
end

function TestQueue:test_queue_iterator_dequeues()
  local q = queue()
  q:enqueue(1)
  q:iter()()
  self:assert_equal(q.size, 0)
end

TestQueue.test_queue_iterator_runs_until_empty = TestCase.args_test {
  call = function(self, range)
    local q = queue()
    for i in fn.range(range) do
      q:enqueue(i)
    end
    self:assert_equal(q.size, range)

    for _ in q:iter() do end
    self:assert_equal(q.size, 0)
  end,
  argsset = {
    { 1 },
    { 10 },
    { 100 },
    { 1000 }
  }
}

function TestQueue:test_queue_can_be_enqueued_while_iterating()
  local q = queue()
  q:enqueue(64)
  local last = nil
  for i in q:iter() do
    if i % 2 == 0 then q:enqueue(i / 2) end
    last = i
  end
  self:assert_equal(last, 1)
end

function TestQueue:test_queue_rawset_disabled()
  local q = queue()
  q:enqueue(64)
  self:expect_failure(function() q[0] = nil end)
end

function TestQueue:test_queue_rawget_disabled()
  local q = queue()
  q:enqueue(64)
  self:expect_failure(function() local _ = q[0] end)
end
